NAME
====

RedJobber - blah blah blah

SYNOPSIS
========

```raku
$ raku -I../Red -MRed -Ilib -MRedJobber -e 'my $*RED-DEBUG = False;
red-defaults "Pg";
my RedJobber $j .= new;
$j.prepare-tables;
$j.map-job: "test", class Bla { has Int $.i; method run { $!i * 2 } };

$j.enqueue: "test", i => 21;

$j.work

'
NOTICE:  drop cascades to constraint job_job_type_id_job_type_id_fkey on table job
RedJobber::Job.new(id => 1, created => DateTime.new(2024,2,1,1,44,49.250394), completed-at => Any, job-type-id => 1, args => \(:i(21)), return => Any)
test
Bla.new(i => 21)
RedJobber::Job.new(id => 1, created => DateTime.new(2024,2,1,1,44,49.250394), completed-at => DateTime.new(2024,2,1,1,44,49.8676176071167), job-type-id => 1, args => \(:i(21)), return => 42)
^C
```

DESCRIPTION
===========

RedJobber is ...

AUTHOR
======

Fernando Corrêa de Oliveira <fco@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright 2024 Fernando Corrêa de Oliveira

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

