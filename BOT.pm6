class TestBot {
    has $.tester;
    has $.channel;

    has %!statistics;

    # Are all prepended with module name
    constant %messages = {
        'PASS' => ' just started passing its test suite.',
        'FAIL' => ' just failed its test suite.',
    };

    method receive_statistics() {
        for $!tester.statistics.kv -> $module, $status {
            next if (%!statistics{$module} // 'PASS') eq $status;
            %!statistics{$module} = $status;

            my $msg = %messages{$status} // " had unexpected status $status";
            # would prefer .tc, but that doesn't seem to work
            $!channel.send($module.wordcase ~ $msg);
        }
    }
}
