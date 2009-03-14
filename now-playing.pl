#! /usr/bin/perl

use Mac::Processes;
use MacPerl 'DoAppleScript';
use Term::ANSIColor;
require Encode;

# Change this string to specify what separates the track information.
my $delimiter = " - ";

# Change this message to specify what is shown if iTunes is paused.
my $paused_message = "";

# Check to see if iTunes is running
if(is_application_running("iTunes")) {
	my $iTunesIsPlaying = DoAppleScript( qq{ tell application "iTunes"\nreturn player state is playing\nend tell } ) or die $@;

	# Show that iTunes is paused
	if($iTunesIsPlaying eq "false") {
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
    $trackRating =~ s/\s+$//;
    $trackLength =~ s/\s+$//;

    # Encode the response from DoAppleScript
    # Encode::from_to($trackName, 'MacRoman', 'utf8');
    # Encode::from_to($artistName, 'MacRoman', 'utf8');
    # Encode::from_to($albumName, 'MacRoman', 'utf8');

    # my $starRating = text_rating($trackRating);

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
	# Parameter $appName - The name of the application that is tested to be running
	my $appName = shift;
	
	# Determine if the specified application is running
	my $isRunning = 0;
	
	# Get the process list and search for the specified name
	PROCESS_LIST:
	while ( my ($psn, $psi) = each(%Process) ) {
		if ($psi->processName eq $appName) {
			$running = 1;
			last PROCESS_LIST;
		}
	}
	
	# Return the running status of the specified application name
	return $running;
}
