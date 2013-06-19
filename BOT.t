# vim: se ft=perl6 :

use lib '.';
use BOT;

use Test;
plan 3;

class Mock::Module::Tester {
    has %.statistics;

    method statistics(%stats?) {
        %!statistics = %stats if %stats;
        %!statistics;
    }
}
class Mock::IRC::Channel {
    has @.messages;

    method clear_messages() {
        @!messages = ();
    }

    method send($msg) {
        push @!messages, $msg
    }
}

sub set_things_up_so_everything_passes {
    my ($tester) = @_;

    $tester.statistics({
        "module C" => "PASS",
        "module W" => "PASS",
    });
    return;
}

sub set_things_up_so_something_fails {
    my ($tester) = @_;

    $tester.statistics({
        "module W" => "FAIL",
        "module C" => "PASS",
    });
    return;
}

{
    my $tester = Mock::Module::Tester.new();
    my $channel = Mock::IRC::Channel.new();
    my $bot = TestBot.new(
        tester => $tester,
        channel => $channel,
    );

    set_things_up_so_everything_passes($tester);
    $bot.receive_statistics();

    set_things_up_so_something_fails($tester);
    $bot.receive_statistics();

    is_deeply $channel.messages(), [
        "Module W just failed its test suite."
    ], "Bot tells channel when module starts failing";
}

{
    my $tester = Mock::Module::Tester.new();
    my $channel = Mock::IRC::Channel.new();
    my $bot = TestBot.new(
        tester => $tester,
        channel => $channel,
    );

    set_things_up_so_something_fails($tester);
    $bot.receive_statistics();
    $channel.clear_messages();

    set_things_up_so_something_fails($tester);
    $bot.receive_statistics();

    is_deeply $channel.messages(), [],
    "Bot keeps quiet when module keeps failing";
}

{
    my $tester = Mock::Module::Tester.new();
    my $channel = Mock::IRC::Channel.new();
    my $bot = TestBot.new(
        tester => $tester,
        channel => $channel,
    );

    set_things_up_so_something_fails($tester);
    $bot.receive_statistics();
    $channel.clear_messages();

    set_things_up_so_everything_passes($tester);
    $bot.receive_statistics();

    is_deeply $channel.messages(), [
        "Module W just started passing its test suite.",
    ], "Bot reports when a module starts passing its test suite again";
}

