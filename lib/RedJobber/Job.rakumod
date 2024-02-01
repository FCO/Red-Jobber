use Red;
use Red::Type::Json;
use JSON::Fast;

unit model RedJobber::Job is table<job>;

has Int         $.id           is serial;
has DateTime    $.created      is column = DateTime.now;
has DateTime    $.completed-at is column{ :nullable } is rw;
has Int         $.job-type-id  is referencing(:model<RedJobber::JobType>, :column<id>);
has             $.job-type     is relationship(*.job-type-id, :model<RedJobber::JobType>, :!optional);
has Capture     $.args         is column{ :type<jsonb>, :deflate{ .&{ %(hash => .hash, list => .list)}.&to-json }, :inflate{ Capture.new: |.&from-json } };
has             $.return       is column{ :nullable, :type<jsonb>, :deflate(*.&to-json), :inflate(*.&from-json) } is rw;

method all-unlocked {
  RedJobber::Job.^all.grep({ !.completed-at && !.job-type.owned-by.defined }).skip-locked
}

method unlocked-supply {
    supply {
        whenever Supply.interval: 1 {
            .emit for self.all-unlocked
        }
    }
}
