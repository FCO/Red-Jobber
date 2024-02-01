use Red;

unit model RedJobber::JobType is table<job_type>;

has Int      $.id       is serial;
has Str      $.name     is unique;
has Str      $.owned-by is column(:nullable) is rw;
has DateTime $.created  is column = DateTime.now;
has          @.jobs     is relationship( { .job-type-id }, :model<RedJobber::Job>);

