package utils;

use strict;

BEGIN { # package module Constructor
    use Exporter;
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    use List::MoreUtils qw/uniq/;
    use YAML::XS qw(LoadFile);
    use Parallel::ForkManager;
    use File::Basename;
    use File::Path qw(make_path remove_tree);

    $VERSION     = 1.00;
    @ISA         = qw(Exporter);
    @EXPORT      = qw($cfg loadcfg splitfile sort_uniq_file run_program print_start_msg print_end_msg fork_run_program);
    @EXPORT_OK   = qw($cfg loadcfg splitfile sort_uniq_file run_program print_start_msg print_end_msg fork_run_program);
    %EXPORT_TAGS = ( DEFAULT => [qw(&cfg &loadcfg &splitfile &sort_uniq_file &run_program &print_start_msg &print_end_msg &fork_run_program)],
                     All    => [qw(&cfg &loadcfg &splitfile &sort_uniq_file &run_program &print_start_msg &print_end_msg &fork_run_program)]);
}

our $cfg = LoadFile("./config.yml");

make_path ($cfg->{data}{datadir});
make_path ($cfg->{data}{sitedata_dir});
make_path ($cfg->{data}{crawled_dir});
make_path ($cfg->{data}{hotels_dir});
make_path ($cfg->{data}{feed_dir});

sub loadcfg {
    my ($cfgfile) = @_;
    return LoadFile($cfgfile);
}

sub run_program {
    my ($program) = @_;

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing started $program at $mday $hour:$min:$sec\n";
    system($program);
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing completed $program at $mday $hour:$min:$sec\n";

}

sub fork_run_program {
    my (@files, $program) = @_;

    my $num_processes = $#files + 1;

    my $pm = new Parallel::ForkManager($num_processes);

    my $f;

    my $cpu_num = 0;

    foreach $f (@files) {
    # Forks and returns the pid for the child:
        my $pid = $pm->start and next;

        my $outfile = basename $f;

        run_program ("$program $f > /tmp/$outfile.out");

        $pm->finish; # Terminates the child process
    }

    $pm->wait_all_children;
}

sub print_start_msg {
    my ($msg) = @_;
    print "Starting task " . $0 . " - " . $msg;
    print "\n";
}

sub print_end_msg {
    my ($msg) = @_;
    print "Completed task " . $0 . " - " . $msg;
    print "\n";
}

sub splitfile {
    my ($infile, $outfile_pattern, $file_len) = @_;

    open(FILE, "<$infile");

    my $num_lines = 0;
    my $part_num = 0;

    my $outfile = $outfile_pattern . "--" . $part_num;
    open (OUT, ">$outfile");

    while(<FILE>)
    {
        print OUT $_; # echo line read

        if ($num_lines < $file_len) {
            $num_lines++;
            next;
        }

        $num_lines = 0;
        $part_num++;

        close (OUT);

        $outfile = $outfile_pattern . "--" . $part_num;
        open (OUT, ">$outfile");
    }

    close(OUT);
    close(FILE);
}

sub sort_uniq_file {
    my ($infile, $outfile) = @_;
 
    # Open infile and read all the lines from the file
    open (IN, "<$infile");
    my @lines = <IN>;
    close (IN);

    #sort and uniq the lines
    my @sort_uniq_lines = uniq sort @lines;

    #write the sorted uniq lines to outfile
    open (OUT, ">$outfile");

    foreach (@sort_uniq_lines) {
        print OUT $_;
    }

    close (OUT);
}

END { } # package module destructor - global destructor

1;


