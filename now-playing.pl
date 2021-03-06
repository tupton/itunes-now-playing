#! /usr/bin/env perl

use Term::ANSIColor;
require Encode;

# Change this string to specify what separates the track information.
my $delimiter = " - ";

# Change this message to specify what is shown if iTunes is paused.
my $paused_message = "";

# Change this to change how much of the track name is printed.
my $TRACK_LENGTH_LIMIT = 100;

# Check to see if iTunes is running
if (is_application_running("iTunes")) {
    my $applescript = qq{ 'tell application "iTunes" to get player state is playing' };
    my $iTunesIsPlaying = qx( osascript -e $applescript );
    chomp $iTunesIsPlaying;

	# Show that iTunes is paused
	if ($iTunesIsPlaying eq "false") {
        print $paused_message;
        die;
	}

    # There are two ways to execute the AppleScript in order to get track info
    # 	DoAppleScript() is faster but does not fully support utf-8 encoded text
    # 	osascript is a slower system call but it returns proper utf-8 encoded text

    # Get the current track name
    # my $trackName = DoAppleScript( qq{ tell application "iTunes"\nset trackName to name of current track\nend tell } ) or die $@;
    my $trackName = qx( osascript -e "tell application \\"iTunes\\"\nreturn name of current track as Unicode text\nend tell" );

    # Get the current artist
    # my $artistName = DoAppleScript( qq{ tell application "iTunes"\nset artistName to artist of current track\nend tell } ) or die $@;
    my $artistName = qx( osascript -e "tell application \\"iTunes\\"\nreturn artist of current track as Unicode text\nend tell" );

    # Get the current album
    # my $artistName = DoAppleScript( qq{ tell application "iTunes"\nset artistName to artist of current track\nend tell } ) or die $@;
    # my $albumName = qx( osascript -e "tell application \\"iTunes\\"\nreturn album of current track as Unicode text\nend tell" );

    # Get the current track's rating
    # my $trackRating = DoAppleScript( qq{ tell application "iTunes"\nreturn rating of current track\nend tell } ) or die $@;
    # my $trackRating = qx( osascript -e "tell application \\"iTunes\\"\nreturn rating of current track as Unicode text\nend tell" );

    # Get the current track's length
    # my $trackLength = qx( osascript -e "tell application \\"iTunes\\"\nreturn time of current track as Unicode text\nend tell" );

    # Trim the double quotes returned by DoAppleScript
    # $trackName =~ s/\"//g;
    # $artistName =~ s/\"//g;
    # $albumName =~ s/\"//g;
    # $trackRating =~ s/\"//g;

    # Trim the end of the AppleScript results
    $trackName =~ s/\s+$//;
    $artistName =~ s/\s+$//;
    # $albumName =~ s/\s+$//;
    # $trackRating =~ s/\s+$//;
    # $trackLength =~ s/\s+$//;

    # Encode the response from DoAppleScript
    # Encode::from_to($trackName, 'MacRoman', 'utf8');
    # Encode::from_to($artistName, 'MacRoman', 'utf8');
    # Encode::from_to($albumName, 'MacRoman', 'utf8');

    # my $starRating = text_rating($trackRating);

    # Truncate the name of the track
    if (length($trackName) > $TRACK_LENGTH_LIMIT) {
        $trackName = substr($trackName, 0, $TRACK_LENGTH_LIMIT) . "...";
    }

    # Print the current track's information
    print "$artistName$delimiter$trackName\n";
}

sub text_rating {
	# Parameter $numericRating - The numeric rating of the current track returned by iTunes
	my $numericRating = shift;
	
	# Create an object to hold the textual star rating of the current track
	my $textualRating = "";
	
	if ($numericRating == 20) {
		$textualRating = "*";
	} elsif ($numericRating == 40) {
		$textualRating = "**";
	} elsif ($numericRating == 60) {
		$textualRating = "***";
	} elsif ($numericRating == 80) {
		$textualRating = "****";
	} elsif ($numericRating == 100) {
		$textualRating = "*****";
	}
	
	return $textualRating;
}

sub is_application_running {
    my $creator = shift;
    $creator =~ s{\\}{\\\\}g;
    $creator =~ s{"}{\\"}g;
    $creator =~ s{'}{'\\''}g;

    my $applescript = qq{ 'tell application "System Events" to count } . 
            qq{ (every process whose name is "$creator")' };
    my $result = qx( osascript -e $applescript );
    chomp $result;

    return $result;
}
