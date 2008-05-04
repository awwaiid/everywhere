package everywhere;

=head1 NAME

everywhere - Use a module (or feature) everywhere

=head1 SYNOPSIS

  #!/usr/bin/perl

  use strict;
  use everywhere qw/ feature say /;
  use Greet;

  Greet::hello();

  # in Greet.pm
  package Greet;
  use strict;
  sub hello {
    say "Helloooooo!!!!";
  }

=head1 DESCRIPTION

I got tired of putting "use 5.010" at the top of every module. So now I can
throw this in my toplevel program and not have to Repeat Myself elsewhere.

In theory you should be able to pass it whatever you pass to use.

=cut

use strict;
use warnings;

our $VERSION = '0.02';

sub import {
  my ($class, $module, @items) = @_;
  my $use_line = "use $module";
  $use_line .= " qw/" . join(' ', @items) if @items;
  $use_line .= ";\n";
  eval $use_line;
  unshift @INC, sub {
    my ($self, $file) = @_;
    foreach my $dir (@INC) {
      next if ref $dir;
      my $full = "$dir/$file";
      if(open my $fh, "<", $full) {
        my @lines = ($use_line);
        return ($fh, sub {
          if(@lines) {
            push @lines, $_;
            $_ = shift @lines;
            return length $_;
          }
          return 0;
        });
      }
    }
  };
  return;
}

=head1 BUGS

Currently you can only use this once.

=head1 SEE ALSO

L<Acme::use::strict::with::pride> -- from which most code came!

Also look at L<use> and L<feature>.

=head1 AUTHOR

  Brock Wilcox <awwaiid@thelackthereof.org> - http://thelackthereof.org/
  Thanks to mst and #moose ;-)

=head1 COPYRIGHT

  Copyright (c) 2008 Brock Wilcox <awwaiid@thelackthereof.org>. All rights
  reserved.  This program is free software; you can redistribute it and/or
  modify it under the same terms as Perl 5.10 or later.

=cut

1;

