package MojoPromiseTest::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures, -async_await;;
use Mojo::Promise;
use Mojo::URL;
use Mojo::UserAgent;

sub welcome ($self) {
  $self->render;
}

sub promise {
  my $self = shift;

  $self->log->info("********** ENTER SUB promise **********");
  $self->render_later;

  my $param = $self->param('query');

  my $results = [];
  my $errors = [];
  my $promise = &_test_async($param)->then(
      sub {
        $self->log->info("Success callback: @_");
        $self->stash('results' => \@_);
        $self->render;},
      sub {
        $self->log->error("Error callback: @_");
        $self->stash('errors' => \@_);
        $self->render;
      }
  );

  # have default blank values. Will be filled once promise resolves/rejects.
  $self->stash('results' => $results, 'errors' => $errors);
  $self->log->info("********** EXIT SUB promise: results=$results : errors=$errors **********");

  return $promise;
}



async sub async_await {
  my $self = shift;

  $self->log->info("********** ENTER SUB async_await **********");

  my (@results, @errors);
  my @promises = (
      &_test_async('hello world'),
      &_test_async,
      &_test_async('Testing 1234'),
      &_test_async('ABCD'),
      &_test_async(undef),
  );

  $self->render_later;

  foreach my $promise (@promises) {
    eval {
      push(@results, await $promise);
      $self->log->info("Success returned: @results");
    };
    if ($@) {
      chomp($@);
      $self->log->error("Error returned: $@");
      push(@errors, $@)
    }
  }

  $self->stash('results' => \@results, 'errors' => \@errors);

  $self->log->info("********** EXIT SUB async_await: results=@results : errors=@errors **********");
  return $self->render;
}


async sub async_await_all_settled {
  my $self = shift;

  $self->log->info("********** ENTER SUB async_await_all_settled **********");

  my (@results, @errors);
  my @promises = (
      &_test_async('hello world'),
      &_test_async,
      &_test_async('Testing 1234'),
      &_test_async('ABCD'),
      &_test_async(undef),
  );

  $self->render_later;

  my @promise_results;
  push(@promise_results, await Mojo::Promise->all_settled(@promises));

  foreach my $pr (@promise_results) {
    if ($pr->{status} eq 'fulfilled') {
      push(@results, $pr->{value}->[0]);
    } elsif ($pr->{status} eq 'rejected') {
      push(@errors, $pr->{reason}->[0]);
    }
  }

  say $self->dumper(\@results);

  $self->stash('results' => \@results, 'errors' => \@errors);

  $self->log->info("********** EXIT SUB async_await_all_settled: results=@results : errors=@errors **********");
  return $self->render;
}


async sub _test_async {
  my ($param) = @_;
  $param //= die "In test_async :: Missing param";
  die "In test_async :: Empty parameter value" if (!length $param);
  say "In test_async :: In test_async with param: $param";

  # This is some extra URL calls pulled async to give the sub something to do so
  # not to return instantly which can lead to a false sense of things working
  # when they're not.
  my $terms = ['mojo', 'minion', 'text', 'log'];
  my $cpan = Mojo::URL->new('http://fastapi.metacpan.org/v1/module/_search');
  my @urls = map { $cpan->clone->query(q => $_) } @$terms;
  my $ua = Mojo::UserAgent->new;

  for my $url (@urls) {
    my $tx = await $ua->get_p($url);
    say $tx->result->json('/hits/hits/0/_source/release');
  }

  return $param;
}



1;
