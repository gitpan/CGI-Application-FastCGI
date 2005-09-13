package CGI::Application::FastCGI;
use strict;
use base qw (CGI::Application);
use FCGI;
use CGI;

our $VERSION = '0.01';

sub run {
    my $self = shift;
    my $request = FCGI::Request();
    $self->fastcgi($request);
    while ($request->Accept >= 0) {
        $self->reset_query;
        $self->SUPER::run;
    }
}

sub reset_query {
    my $self = shift;
    CGI::_reset_globals();
    $self->{__QUERY_OBJ} = $self->cgiapp_get_query;
}

sub fastcgi {
    my $self = shift;
    @_ ? $self->{__FASTCGI} = shift : $self->{__FASTCGI};
}

1;

__END__

=head1 NAME

CGI::Application::FastCGI - for using CGI::Application under FastCGI

=head1 SYNOPSIS

  # In "WebApp.pm"...
  package WebApp;
  use base qw(CGI::Application::FastCGI);
  sub setup {
    ...
  }
  1;

  # In "webapp.fcgi"...
  use WebApp;
  my $webapp = WebApp->new;
  $webapp->run;

=head1 DESCRIPTION

Inherit this module instead of CGI::Application if you want to run your cgi programs based on CGI::Application under FastCGI.

=head1 NOTES

Note that cgiapp_init() is called only once under lifecycle of FastCGI. So if you want to do something for every REQUESTS, you should write the logic in cgiapp_prerun().

=head1 SEE ALSO

L<CGI::Application>, L<FCGI>

=head1 AUTHOR

Naoya Ito E<lt>naoya@naoya.dyndns.orgE<gt>

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
