package MojoPromiseTest;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Example#welcome');
  $r->get('/promise')->to('Example#promise');
  $r->get('/async_await')->to('Example#async_await');
  $r->get('/async_await_all_settled')->to('Example#async_await_all_settled');
}

1;
