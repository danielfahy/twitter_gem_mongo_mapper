// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// =require_tree
// =require javascripts
//= require jquery
//= require jquery_ujs
//= require_tree


function isValidTwitterID(string) {

	if (/^[0-9A-Za-z_]+$/.test(string) && string.length < 16 && !containsBannedString(string) ) // Check that all banned conditions are false!
	{ //there are only alphanumeric characters and length is 15 or less then it isValidTwitterID
    	return true
    } 
    else 
	{return false
	}
}

function containsBannedString(string) { 
// This function returns true if the input string contains strings banned from twitter usernames, else it returns false

	 string=string.toLowerCase();									
return ((string.indexOf("twitter") != -1) || (string.indexOf("admin") != -1))
}

function checkTwitterID(input) {
	var enteredValue = input.value;

	// If TwitterID is invalid fire alert to user and reset input to blank
	if (!isValidTwitterID(enteredValue)) {
		if (enteredValue==''){enteredValue='\'Blank\''}
		alert(enteredValue +' is not a valid Twitter Username!'); 
		input.value = '';
	} 
	setButtons();	

}

function setButtons() {
	var a = document.getElementById('user_twitter_display_name').value;
	var button = document.getElementById('submit_button');

	if (isValidTwitterID(a)) {  // If Valid TwitterID enable submit button
			button.disabled=false;
		} 
	
	else { 						// If invalid TwitterID disable button
			button.disabled=true;  
	}
} 

function loadLastThreeTweets(TwitterID) {
	console.log(TwitterID)
}