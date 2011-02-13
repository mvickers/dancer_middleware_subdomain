package Dancer::Middleware::Subdomain;
use strict;
use parent qw(Plack::Middleware);
use Data::Dumper;

sub ignore_subdomains {
    our %ignore_subdomains;
    if(!defined(%ignore_subdomains)) {
        %ignore_subdomains = map { $_ => 1 } @{ $self->{ ignore_subdomains } };
    }
    return \%ignore_subdomains;
}

sub call {
    my($self, $env) = @_;
    my $domain = $self->{ domain };
    $env->{ SUBDOMAIN } = "";
    $env->{ HTTP_HOST } =~ /^(.+?)\.$domain/;
    my $subdomain = $1;
    if($subdomain)
    {
        $env->{ SUBDOMAIN } = $subdomain unless($self->ignore_subdomains->{ $subdomain });
    }
    $self->app->($env);
};

1;