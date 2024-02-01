use Red;
unit class RedJobber;

use RedJobber::Job;
use RedJobber::JobType;

=begin pod

=head1 NAME

RedJobber - blah blah blah

=head1 SYNOPSIS

=begin code :lang<raku>

use RedJobber;

=end code

=head1 DESCRIPTION

RedJobber is ...

=head1 AUTHOR

Fernando Corrêa de Oliveira <fco@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2024 Fernando Corrêa de Oliveira

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

has %!type;
has %.job;

multi trait_mod:<is>(Method $m, :$red-transaction) {
  $m.wrap: method (|) {
    red-do { callsame }, :transaction
  }
}

method prepare-tables { schema(RedJobber::Job, RedJobber::JobType).drop.create }

method map-job(Str $name, $obj, :$owned-by) { # is red-transaction {
  %!type{$name} //= RedJobber::JobType.^find(:$name) // RedJobber::JobType.^create: :$name, |(:$owned-by with $owned-by);
  %!job{$name} = $obj
}

method enqueue(Str $name, |args) {
  %!type{$name}.jobs.create: :args(args)
}

method work {
  react {
    whenever RedJobber::Job.unlocked-supply -> RedJobber::Job $job {
      red-do :transaction, {
        say $job;
        say $job.job-type.name;
        my $obj = %!job{ $job.job-type.name }.new: |$job.args;
        say $obj;
        $job.return = $obj.run;
        $job.completed-at = DateTime.now;
        $job.^save;
        say $job
      }
    }
  }
}
