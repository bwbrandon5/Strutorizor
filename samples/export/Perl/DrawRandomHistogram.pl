#!/usr/bin/perl
# Generated by Structorizer 3.30-07 

# Copyright (C) 2020-03-21 Kay Gürtzig 
# License: GPLv3-link 
# GNU General Public License (V 3) 
# https://www.gnu.org/licenses/gpl.html 
# http://www.gnu.de/documents/gpl.de.html 

use strict;
use warnings;
use Class::Struct;

# TODO: This algorithm made use of the Structorizer File API, 
#       which cannot not be translated completely. 
#       Watch out for "TODO FileAPI" comments and try to adapt 
#       the code according to the recommendations. 
#       See e.g. http://perldoc.perl.org/perlopentut.html 

sub finally (&) { Finally->new(@_) }

# Draws a bar chart from the array "values" of size nValues. 
# Turtleizer must be activated and will scale the chart into a square of 
# 500 x 500 pixels 
# Note: The function is not robust against empty array or totally equal values. 
sub drawBarChart {
    my $values = $_[0];
    my $nValues = $_[1];

    my $ySize;
    my $yScale;
    my $yAxis;
    my $xSize;
    my $valMin;
    my $valMax;
    my $stripeWidth;
    my $stripeHeight;
    my $kMin;
    my $kMax;
    my $k;

    # Used range of the Turtleizer screen 
    $xSize = 500;
    $ySize = 500;
    $kMin = 0;
    $kMax = 0;

    for ($k = 1; $k <= $nValues-1; $k += (1)) {

        if ( $$values[$k] > $$values[$kMax] ) {
            $kMax = $k;
        }
        else {

            if ( $$values[$k] < $$values[$kMin] ) {
                $kMin = $k;
            }

        }

    }

    $valMin = $$values[$kMin];
    $valMax = $$values[$kMax];
    $yScale = $valMax * 1.0 / ($ySize - 1);
    $yAxis = $ySize - 1;

    if ( $valMin < 0 ) {

        if ( $valMax > 0 ) {
            $yAxis = $valMax * $ySize * 1.0 / ($valMax - $valMin);
            $yScale = ($valMax - $valMin) * 1.0 / ($ySize - 1);
        }
        else {
            $yAxis = 1;
            $yScale = $valMin * 1.0 / ($ySize - 1);
        }

    }

    # draw coordinate axes 
    gotoXY(1, $ySize - 1);
    forward($ySize -1); # color = ffffff
    penUp();
    backward($yAxis); # color = ffffff
    right(90);
    penDown();
    forward($xSize -1); # color = ffffff
    penUp();
    backward($xSize-1); # color = ffffff
    $stripeWidth = $xSize / $nValues;

    for ($k = 0; $k <= $nValues-1; $k += (1)) {
        $stripeHeight = $$values[$k] * 1.0 / $yScale;

        switch ( $k % 3 ) {

            case (0) {
                setPenColor(255,0,0);
            }

            case (1) {
                setPenColor(0, 255,0);
            }

            case (2) {
                setPenColor(0, 0, 255);
            }
        }

        fd(1); # color = ffffff
        left(90);
        penDown();
        fd($stripeHeight); # color = ffffff
        right(90);
        fd($stripeWidth - 1); # color = ffffff
        right(90);
        forward($stripeHeight); # color = ffffff
        left(90);
        penUp();
    }

}

# Tries to read as many integer values as possible upto maxNumbers 
# from file fileName into the given array numbers. 
# Returns the number of the actually read numbers. May cause an exception. 
sub readNumbers {
    my $fileName = $_[0];
    my $numbers = $_[1];
    my $maxNumbers = $_[2];

    my $number;
    my $nNumbers;
    my $fileNo;

    $nNumbers = 0;
    open($fileNo, "<", $fileName) or die "Failed to open $fileName";

    # TODO FileAPI: Consider replacing / dropping this now inappropriate file test. 
    if ( $fileNo <= 0 ) {
        die "File could not be opened!";
    }

    eval {
        my $finale2a9676a = finally {
            close($fileNo);
        };

        # TODO FileAPI: Replace the fileEOF test by something like «<DATA>» in combination with «$_» for the next fileRead 
        while ( ! fileEOF($fileNo) && $nNumbers < $maxNumbers ) {
            # TODO FileAPI: Originally this was a fileReadInt call, so ensure to obtain the right thing! 
            $number = <$fileNo> ;
            $$numbers[$nNumbers] = $number;
            $nNumbers = $nNumbers + 1;
        }

    };
    if (my $exe2a9676a = $@) {
        die ;
    };
    return $nNumbers;
}
# Reads a random number file and draws a histogram accotrding to the 
# user specifications 

my $width;
my $value;
my @numberArray;
my $nObtained;
my $nIntervals;
my $min;
my $max;
my $kMaxCount;
my $k;
my $i;
my $file_name;
my $fileNo;
my @count;

$fileNo = -10;

do {
    print "Name/path of the number file"; chomp($file_name = <STDIN>);
    open($fileNo, "<", $file_name) or die "Failed to open $file_name";
} while (!( $fileNo > 0 || $file_name == "" ));


# TODO FileAPI: Consider replacing / dropping this now inappropriate file test. 
if ( $fileNo > 0 ) {
    close($fileNo);
    print "number of intervals"; chomp($nIntervals = <STDIN>);

    # Initialize the interval counters 
    for ($k = 0; $k <= $nIntervals-1; $k += (1)) {
        $count[$k] = 0;
    }

    # Index of the most populated interval 
    $kMaxCount = 0;
    @numberArray = ();
    $nObtained = 0;
    eval {
        $nObtained = readNumbers($file_name, \@numberArray, 10000);
    };
    if (my $ex32f18dfb = $@) {
        print failure, "\n";
    };

    if ( $nObtained > 0 ) {
        $min = $numberArray[0];
        $max = $numberArray[0];

        for ($i = 1; $i <= $nObtained-1; $i += (1)) {

            if ( $numberArray[$i] < $min ) {
                $min = $numberArray[$i];
            }
            else {

                if ( $numberArray[$i] > $max ) {
                    $max = $numberArray[$i];
                }

            }

        }

        # Interval width 
        $width = ($max - $min) * 1.0 / $nIntervals;

        for ($i = 0; $i <= $nObtained - 1; $i += (1)) {
            $value = $numberArray[$i];
            $k = 1;

            while ( $k < $nIntervals && $value > $min + $k * $width ) {
                $k = $k + 1;
            }

            $count[$k-1] = $count[$k-1] + 1;

            if ( $count[$k-1] > $count[$kMaxCount] ) {
                $kMaxCount = $k-1;
            }

        }

        drawBarChart(\@count, $nIntervals);
        print "Interval with max count: ", $kMaxCount, " (", $count[$kMaxCount], ")", "\n";

        for ($k = 0; $k <= $nIntervals-1; $k += (1)) {
            print $count[$k], " numbers in interval ", $k, " (", $min + $k * $width, " ... ", $min + ($k+1) * $width, ")", "\n";
        }

    }
    else {
        print "No numbers read.", "\n";
    }

}

# ---------------------------------------------------------------------- 
#  Finally class, introduced to handle finally blocks via RAII 
# ---------------------------------------------------------------------- 
package Finally;
sub new {
    my ($class, $code) = @_;
    bless {code => $code}, $class;
}
sub DESTROY { my ($self) = @_; $self->{code}->() }