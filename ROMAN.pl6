sub to_roman($_ is copy) {
    my $ret = '';

    for <
        M D C 100
        C L X 10
        X V I 1
    > -> $ten, $five, $one, $mult {
        while $_ >= 10 * $mult {
            $ret ~= $ten;
            $_ -= 10 * $mult;
        }
        if $_ >= 9 * $mult {
            $ret ~= $one ~ $ten;
            $_ -= 9 * $mult;
        }
        if $_ >= 5 * $mult {
            $ret ~= $five;
            $_ -= 5 * $mult;
        }
        if $_ >= 4 * $mult {
            $ret ~= $one ~ $five;
            $_ -= 4 * $mult;
        }
    }
    while $_ > 0 {
        $ret ~= 'I';
        $_--;
    }

    return $ret;
}

multi MAIN(Int $n) {
    say to_roman($n);
}

multi MAIN() {
    use Test;

    my @tests = <
           1 I
           5 V
          10 X
          50 L
         100 C
         500 D
        1000 M
           2 II
           3 III
           4 IV
           6 VI
           7 VII
           8 VIII
           9 IX
        1666 MDCLXVI
         444 CDXLIV
         999 CMXCIX
        2222 MMCCXXII
        3333 MMMCCCXXXIII
        4444 MMMMCDXLIV
    >;
    for @tests -> $n, $s {
        is to_roman($n), $s, "$n gets converted to $s";
    }
}
