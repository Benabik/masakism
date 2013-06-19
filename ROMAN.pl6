sub to_roman($_ is copy) {
    my $ret = '';

    for <
        1000 M
        500  D
        100  C
        50   L
        10   X
        5    V
        1    I
    > -> $n, $s {
        while $_ >= $n {
            $ret ~= $s;
            $_ -= $n;
        }
    }

    return $ret;
}

multi MAIN(Int $n) {
    say to_roman($n);
}

multi MAIN() {
    use Test;

    my @tests = <
        1    I
        3    III
        4    IV
        5    V
        10   X
        50   L
        100  C
        500  D
        1000 M
    >;
    for @tests -> $n, $s {
        is to_roman($n), $s, "$n gets converted to $s";
    }
}
