var DEBUG_MASTER = false;
var countDown = $('.countdown');
if( DEBUG_MASTER ) console.log($('.countdown').data("targetdate"));
var days = $('.days'),
hours = $('.hours'),
minutes = $('.minutes'),
seconds = $('.seconds'),
targetDate = new Date(countDown.data("targetdate")).getTime(),
timeDiffrence = {};
        
function zeroFill( number, width ) {
	width -= number.toString().length;
	if ( width > 0 )
	{
	  return new Array( width + (/\./.test( number ) ? 2 : 1) ).join( '0' ) + number;
	}
	return number + ""; // always return a string
}

function calculateTimeDiffrence (currentDate, targetDate) {
	var tmpTime = targetDate - currentDate;
	if( DEBUG_MASTER ) console.log(targetDate + ', ' + currentDate);
	if( DEBUG_MASTER ) console.log(tmpTime);
	if (timeDiffrence) {
			timeDiffrence.days = zeroFill(Math.floor(tmpTime/1000/60/60/24), 2);
			tmpTime -= timeDiffrence.days*24*60*60*1000;
			timeDiffrence.hours = zeroFill(Math.floor(tmpTime/1000/60/60), 2);
			tmpTime -= timeDiffrence.hours*60*60*1000;
			timeDiffrence.minutes = zeroFill(Math.floor(tmpTime/1000/60), 2);
			tmpTime -= timeDiffrence.minutes*60*1000;
			timeDiffrence.seconds = zeroFill(Math.floor(tmpTime/1000), 2);
			if( DEBUG_MASTER ) console.log(timeDiffrence);
	}
}

function updateCountDown (countDown) {
	var currentDate = new Date().getTime();
	if( DEBUG_MASTER ) console.log(currentDate);
	if( DEBUG_MASTER ) console.log($('.countdown'));
	calculateTimeDiffrence(currentDate, targetDate);
	days.text(timeDiffrence.days);
	hours.text(timeDiffrence.hours);
	minutes.text(timeDiffrence.minutes);
	seconds.text(timeDiffrence.seconds);
}

(function() {
nIntervId = setInterval(updateCountDown, 1000);
})();
