sub to_roman($num is copy) {
    my $ret = '';

    sub digit($n, $s) {
        while $num >= $n {
            $ret ~= $s;
            $num -= $n;
        }
    }

    digit 1000, 'M';
    for <
        M D C 100
        C L X 10
        X V I 1
    > -> $ten, $five, $one, $mult {
        digit  9 * $mult, $one ~ $ten;
        digit  5 * $mult, $five;
        digit  4 * $mult, $one ~ $five;
        digit      $mult, $one
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
