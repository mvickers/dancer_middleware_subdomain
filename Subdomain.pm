package Dancer::Middleware::Subdomain;
use strict;
use parent qw(Plack::Middleware);
use Data::Dumper;

sub call {
    my($self, $env) = @_;
    my $domain = $self->{ domain };
    my %ignore_subdomains = map { $_ => 1 } @{ $self->{ ignore_subdomains } };
    $env->{ SUBDOMAIN } = "";
    $env->{ HTTP_HOST } =~ /^(.+?)\.$domain/;
    my $subdomain = $1;
    if($subdomain)
    {
        $env->{ SUBDOMAIN } = $subdomain unless($ignore_subdomains{ $subdomain });
    }
    $self->app->($env);
};

1;