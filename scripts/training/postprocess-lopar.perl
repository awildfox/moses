#!/usr/bin/perl -w

use strict;

use utf8;

my $out = shift @ARGV or die "Please specify the output file path (will be appended with .lemma .morph and .words and .factored";

my $wc = 0;
my $uc = 0;
open OUT, ">$out.factored" or die "Couldn't open joined";
open M, ">$out.morph" or die "Couldn't open morph";
open L, ">$out.lemma" or die "Couldn't open lemma";
open S, ">$out.words" or die "Couldn't open surface";
my $lc = 0;
while (my $l =<STDIN>) {
  chomp $l;
	$lc++;
  if ($lc % 1000 == 0) {print "$lc\n";}
	my @ls = (); my @ms = ();  my @ss = (); my @js = ();
  my @ws = split /\s+/, $l;
  foreach my $w (@ws) {
		$wc++;
    my ($surface, $morph, $lemma) = split /_/, $w;
		if (!defined $lemma) { $lemma=$surface; }
		if (!defined $morph) { $morph = 'NN.Neut.Cas.Sg'; }
		if ($lemma eq '<NUM>' || $lemma eq '<ORD>') {
			$lemma = $surface;
		}

    $surface =~ tr/A-Z/a-z/;
    $surface =~ tr/À-Þ/à-þ/;

		if ($lemma eq '<unknown>') {
			$uc++;
			$lemma = $surface;
      if ($surface =~ /ungen$/o) {
				$lemma =~ s/en$//o;
				$morph = 'NN.Fem.Cas.Pl';
      } elsif ($surface =~ /schaften$/o) {
				$lemma =~ s/en$//o;
				$morph = 'NN.Fem.Cas.Pl';
      } elsif ($surface =~ /eiten$/o) {
				$lemma =~ s/en$//o;
				$morph = 'NN.Fem.Cas.Pl';
			} elsif ($surface =~ /eit/o) {
				$morph = 'NN.Fem.Cas.Sg';
			} elsif ($surface =~ /schaft/o) {
				$morph = 'NN.Fem.Cas.Sg';
			} elsif ($surface =~ /ung/o) {
				$morph = 'NN.Fem.Cas.Sg';
			} elsif ($surface =~ /ismus$/o) {
				$morph =~ 'NN.Masc.Cas.Sg';
			}
    }
		my ($pos, @xs) = split /\./, $morph;
		$morph = join '.', @xs;
    if (!defined $morph || $morph eq '') {
			$morph = '-';
		} 
		if ($lemma =~ /\|/o) {
			my ($l, @rest) = split /\|/o, $lemma;
			$lemma = $l;
		}
    if ($lemma && $morph && $surface) {
			push @js, "$surface|$morph|$lemma";
			push @ls, $lemma;
			push @ms, $morph;
			push @ss, $surface;
		}
  }
	print OUT join(' ', @js) . "\n";
	print M join(' ', @ms) . "\n";
	print L join(' ', @ls) . "\n";
	print S join(' ', @ss) . "\n";
}
close OUT;

print "word count: $wc\nunknown lemmas: $uc\nratio: " . $uc/$wc . "\n";
