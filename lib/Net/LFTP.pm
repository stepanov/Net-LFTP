package LFTP;

use strict;
use warnings;

sub new {
        my $this = shift;
        my $class = ref($this) || $this;

        my $self = {};
        bless $self, $class;
        $self->_initialize(@_);

        return $self;
}

sub _initialize {
        my $self = shift;
        my $host = shift;
        my %params = @_;

        $self->{host} = $host;

        map { $self->{$_} = $params{$_} } keys %params;

        $self->{options} = 'set ftp:ssl-protect-data true;';
        $self->{options} .= "debug $params{debug};" if $params{debug};
}

sub login {
        my $self = shift;
        my($user_name, $password) = @_;

        $self->{user_name} = $user_name;
        $self->{password} = $password;

        return 1;
}

sub message {
        my $self = shift;

        return "Just a message!";
}

sub ls {
        my $self = shift;

        my $ret = `lftp -c 'open -u $self->{user_name},$self->{password} ftps://$self->{host}:$self->{port}; cls'`;

        $ret =~ s#/##g;

        my @res = map { $_ } split /\s+/, $ret;

        print "[$ret] --> [@res]\n";

        return @res;
}

sub pwd {
        my $self = shift;

        return "This is JCC. No needed PWD!";
}

sub cwd {
        my $self = shift;
        my $dest = shift;

        print "CHDIR $dest ...\n";

        $self->{rdest} = $dest;

        return 1;
}

sub get {
        my $self = shift;
        my $file = shift;

        my $cmd = "lftp -c '$self->{options} open -u $self->{user_name},$self->{password} ftps://$self->{host}:$self->{port}; ";
        $cmd .= "cd $self->{rdest}; get $file'";

        my $ret = system $cmd;

        print "run [$cmd]: $ret\n";

        return $ret;
}

sub put {
        my $self = shift;
        my $file = shift;

        my $cmd = "lftp -c '$self->{options} open -u $self->{user_name},$self->{password} ftps://$self->{host}:$self->{port}; ";
        $cmd .= "cd $self->{rdest}; put $file'";

        my $ret = system $cmd;
        print "run [$cmd]: $ret\n";

        return $ret;
}

sub delete {
        my $self = shift;
        my $file = shift;

        my $cmd = "lftp -c '$self->{options} open -u $self->{user_name},$self->{password} ftps://$self->{host}:$self->{port}; ";
        $cmd .= "cd $self->{rdest}; delete $file'";

        my $ret = system $cmd;
        print "run [$cmd]: $ret\n";

        return $ret;
}

1;


__END__

=head1 NAME

Net::LFTP - Perl extension for lftp

=head1 SYNOPSIS

  use Net::LFTP;

=head1 DESCRIPTION


=head2 EXPORT

None by default.


=head1 SEE ALSO

=head1 AUTHOR

Michael Stepanov <lt>michael@stepanoff.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Michael Stepanov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
