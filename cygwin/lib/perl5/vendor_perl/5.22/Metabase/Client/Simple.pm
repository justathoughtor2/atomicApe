use 5.006;
use strict;
use warnings;

package Metabase::Client::Simple;
# ABSTRACT: a client that submits to Metabase servers

our $VERSION = '0.010';

use HTTP::Status 5.817 qw/:constants/;
use HTTP::Request::Common ();
use JSON 2 ();
use LWP::UserAgent 5.54 (); # keep_alive
use URI;

my @valid_args;

BEGIN {
    @valid_args = qw(profile secret uri);

    for my $arg (@valid_args) {
        no strict 'refs';
        *$arg = sub { $_[0]->{$arg}; }
    }
}

#pod =method new
#pod
#pod   my $client = Metabase::Client::Simple->new(\%arg)
#pod
#pod This is the object constructor.
#pod
#pod Valid arguments are:
#pod
#pod   profile - a Metabase::User::Profile object
#pod   secret  - a Metabase::User::Secret object
#pod   uri     - the root URI for the metabase server
#pod
#pod If you use a C<uri> argument with the 'https' scheme, you must have
#pod L<LWP::Protocol::https> installed.
#pod
#pod =cut

sub new {
    my ( $class, @args ) = @_;

    my $args = $class->__validate_args( \@args, { map { $_ => 1 } @valid_args } );

    # uri must have a trailing slash
    $args->{uri} .= "/" unless substr( $args->{uri}, -1 ) eq '/';

    my $self = bless $args => $class;

    unless ( $self->profile->isa('Metabase::User::Profile') ) {
        Carp::confess("'profile' argument for $class must be a Metabase::User::Profile");
    }
    unless ( $self->secret->isa('Metabase::User::Secret') ) {
        Carp::confess("'profile' argument for $class must be a Metabase::User::secret");
    }

    my $scheme = URI->new( $self->uri )->scheme;
    unless ( $self->_ua->is_protocol_supported($scheme) ) {
        my $msg = "Scheme '$scheme' is not supported by your LWP::UserAgent.\n";
        if ( $scheme eq 'https' ) {
            $msg .= "You must install Crypt::SSLeay or IO::Socket::SSL or use http instead.\n";
        }
        die $msg;
    }

    return $self;
}

sub _ua {
    my ($self) = @_;
    if ( !$self->{_ua} ) {
        $self->{_ua} = LWP::UserAgent->new(
            agent      => __PACKAGE__ . "/" . __PACKAGE__->VERSION . " ",
            env_proxy  => 1,
            keep_alive => 5,
        );
    }
    return $self->{_ua};
}

#pod =method submit_fact
#pod
#pod   $client->submit_fact($fact);
#pod
#pod This method will submit a L<Metabase::Fact|Metabase::Fact> object to the
#pod client's server.  On success, it will return a true value.  On failure, it will
#pod raise an exception.
#pod
#pod =cut

sub submit_fact {
    my ( $self, $fact ) = @_;

    my $path = sprintf 'submit/%s', $fact->type;

    $fact->set_creator( $self->profile->resource )
      unless $fact->creator;

    my $req_uri = $self->_abs_uri($path);

    my $req = HTTP::Request::Common::POST(
        $req_uri,
        Content_Type => 'application/json',
        Accept       => 'application/json',
        Content      => JSON->new->ascii->encode( $fact->as_struct ),
    );
    $req->authorization_basic( $self->profile->resource->guid, $self->secret->content );

    my $res = $self->_ua->request($req);

    if ( $res->code == HTTP_UNAUTHORIZED ) {
        if ( $self->guid_exists( $self->profile->guid ) ) {
            Carp::confess $self->_error( $res => "authentication failed" );
        }
        $self->register; # dies on failure
        # should now be registered so try again
        $res = $self->_ua->request($req);
    }

    unless ( $res->is_success ) {
        Carp::confess $self->_error( $res => "fact submission failed" );
    }

    # This will be something more informational later, like "accepted" or
    # "queued," maybe. -- rjbs, 2009-03-30
    return 1;
}

#pod =method guid_exists
#pod
#pod   $client->guid_exists('2f8519c6-24cf-11df-90b1-0018f34ec37c');
#pod
#pod This method will check whether the given GUID is found on the metabase server.
#pod The GUID must be in lower-case, string form.  It will return true or false.
#pod Note that a server error will also result in a false value.
#pod
#pod =cut

sub guid_exists {
    my ( $self, $guid ) = @_;

    my $path = sprintf 'guid/%s', $guid;

    my $req_uri = $self->_abs_uri($path);

    my $req = HTTP::Request::Common::HEAD($req_uri);

    my $res = $self->_ua->request($req);

    return $res->is_success ? 1 : 0;
}

#pod =method register
#pod
#pod   $client->register;
#pod
#pod This method will submit the user credentials to the metabase server.  It will
#pod be called automatically by C<submit_fact> if necessary.   You generally won't
#pod need to use it.  On success, it will return a true value.  On failure, it will
#pod raise an exception.
#pod
#pod =cut

sub register {
    my ($self) = @_;

    my $req_uri = $self->_abs_uri('register');

    for my $type (qw/profile secret/) {
        $self->$type->set_creator( $self->$type->resource )
          unless $self->$type->creator;
    }

    my $req = HTTP::Request::Common::POST(
        $req_uri,
        Content_Type => 'application/json',
        Accept       => 'application/json',
        Content      => JSON->new->ascii->encode(
            [ $self->profile->as_struct, $self->secret->as_struct ]
        ),
    );

    my $res = $self->_ua->request($req);

    unless ( $res->is_success ) {
        Carp::confess $self->_error( $res => "registration failed" );
    }

    return 1;
}

#--------------------------------------------------------------------------#
# private methods
#--------------------------------------------------------------------------#

# Stolen from ::Fact.
# XXX: Should refactor this into something in Fact, which we can then rely on.
# -- rjbs, 2009-03-30
sub __validate_args {
    my ( $self, $args, $spec ) = @_;
    my $hash =
        ( @$args == 1 and ref $args->[0] ) ? { %{ $args->[0] } }
      : ( @$args == 0 ) ? {}
      :                   {@$args};

    my @errors;

    for my $key ( keys %$hash ) {
        push @errors, qq{unknown argument "$key" when constructing $self}
          unless exists $spec->{$key};
    }

    for my $key ( grep { $spec->{$_} } keys %$spec ) {
        push @errors, qq{missing required argument "$key" when constructing $self}
          unless defined $hash->{$key};
    }

    Carp::confess( join qq{\n}, @errors ) if @errors;

    return $hash;
}

sub _abs_uri {
    my ( $self, $str ) = @_;
    my $req_uri = URI->new($str)->abs( $self->uri );
}

sub _error {
    my ( $self, $res, $prefix ) = @_;
    $prefix ||= "unrecognized error";
    if ( ref($res) && $res->header('Content-Type') eq 'application/json' ) {
        my $entity = JSON->new->ascii->decode( $res->content );
        return "$prefix\: $entity->{error}";
    }
    else {
        return "$prefix\: " . $res->message;
    }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Metabase::Client::Simple - a client that submits to Metabase servers

=head1 VERSION

version 0.010

=head1 SYNOPSIS

  use Metabase::Client::Simple;
  use Metabase::User::Profile;
  use Metabase::User::Secret;

  my $profile = Metabase::User::Profile->load('user.profile.json');
  my $secret  = Metabase::User::Secret ->load('user.secret.json' );

  my $client = Metabase::Client::Simple->new({
    profile => $profile,
    secret  => $secret,
    uri     => 'http://metabase.example.com/',
  });

  my $fact = generate_metabase_fact;

  $client->submit_fact($fact);

=head1 DESCRIPTION

Metabase::Client::Simple provides is extremely simple, lightweight library for
submitting facts to a L<Metabase|Metabase> web server.

=head1 METHODS

=head2 new

  my $client = Metabase::Client::Simple->new(\%arg)

This is the object constructor.

Valid arguments are:

  profile - a Metabase::User::Profile object
  secret  - a Metabase::User::Secret object
  uri     - the root URI for the metabase server

If you use a C<uri> argument with the 'https' scheme, you must have
L<LWP::Protocol::https> installed.

=head2 submit_fact

  $client->submit_fact($fact);

This method will submit a L<Metabase::Fact|Metabase::Fact> object to the
client's server.  On success, it will return a true value.  On failure, it will
raise an exception.

=head2 guid_exists

  $client->guid_exists('2f8519c6-24cf-11df-90b1-0018f34ec37c');

This method will check whether the given GUID is found on the metabase server.
The GUID must be in lower-case, string form.  It will return true or false.
Note that a server error will also result in a false value.

=head2 register

  $client->register;

This method will submit the user credentials to the metabase server.  It will
be called automatically by C<submit_fact> if necessary.   You generally won't
need to use it.  On success, it will return a true value.  On failure, it will
raise an exception.

=for Pod::Coverage profile secret uri

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/cpan-testers/Metabase-Client-Simple/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/cpan-testers/Metabase-Client-Simple>

  git clone https://github.com/cpan-testers/Metabase-Client-Simple.git

=head1 AUTHORS

=over 4

=item *

David Golden <dagolden@cpan.org>

=item *

Ricardo Signes <rjbs@cpan.org>

=back

=head1 CONTRIBUTORS

=for stopwords Alexandr Ciornii David Steinbrunner

=over 4

=item *

Alexandr Ciornii <alexchorny@gmail.com>

=item *

David Steinbrunner <dsteinbrunner@pobox.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2015 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
