# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

RegExp.escape = (string) =>
    return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')


jQuery ->


	if document.referrer == "http://localhost:3000/" or document.referrer == "http://olac-annotator.herokuapp.com/"
		$('#helpModal').modal('show')
		

	#
	# This make the Interest box text color rotate to keep things from getting monotonous.
	#
	bgcolorlist= ["#DFDFFF", "#FFFFBF", "#80FF80", "#EAEAFF", "#C9FFA8", "#F7F7F7", "#FFFFFF", "AFEEEE" ] 
	bgcolor = bgcolorlist[Math.floor(Math.random()*bgcolorlist.length)]
	$("div.well.interest").css('background-color', bgcolor)


	# 
	# This highlights the text in the insights field when it's being entered 
	#
	replaceInterestText = (klass) =>
		newClass = klass.replace(".", "highlight-")		
		$("#random_interest").unhighlight({ element: 'em', className: newClass })
		$.each $(klass), (index, value) ->
			texts = this.value.split " "
			for text in texts
			  $("#random_interest").highlight(RegExp.escape(text), { element: 'em', className: newClass })
	
	$(".insights-fields").on( 'keyup', ".role-in-credit", ( -> 
		replaceInterestText(".role-in-credit")
	))
	
	$(".insights-fields").on( 'keyup', ".name-in-credit", ( -> 
		replaceInterestText(".name-in-credit")
	))
	
	# Request to only have one language-fields section present per form. This hides the values but sets the values to all match.
	$(".language-fields:eq(0)").show();
	$(".comment-field:eq(0)").show();
	
	
	
	#
	# These are the form validation methods
	#
	# Does the actual looping and checking for values
	#
	# These are the form validation methods
	#
	# Does the actual looping and checking for values
	checkIfAllWordsArePresent = (credit, words, isEmptyOk = false ) =>
		return true if words.length < 1 and isEmptyOk == true
		result = true
		credit = " " + credit + " "
		checkWords = words.split " "
		for checkWord in checkWords
		  searcher = new RegExp("(\\s)" + RegExp.escape(checkWord) + "(\\W)?(\\s)", "gi")
		  reg = credit.search(searcher)
		  result = false if credit.search(searcher) < 0
		#return false
		result

      
	# This checks that the name values are found in the Interest
	$.validator.addMethod "nameValueInCredit", ( (value, element) ->
    interest = $("#random_interest").text()
  #  words = value.split(" ")
    checkIfAllWordsArePresent(interest, value)
    ), "The text for the name should be copied exactly from the credit text above."
	
	# This checks that the role values are found in the Interest. This field can be empty, but if it has a value, it must be validataed. 
	$.validator.addMethod "roleValueInCredit", ( (value, element) ->
    interest = $("#random_interest").text()
  #  words = value.split(" ")
    checkIfAllWordsArePresent(interest, value, true)
    ), "The text for the role should be copied exactly from the credit text above. If there is no text indicating a role, you can leave this field blank. "
	

	
	validator = $("form").validate
	  rules:
	    "select.language-pulldown":
	      required: true
		  ".name-in-credit":
			  nameValueInCredit: true
			".role-in-credit":
  			roleValueInCredit: true


	  showErrors: (errorMap, errorList) ->
	    $.each @successList, (index, value) ->
	      $(value).popover "hide"

	    $.each errorList, (index, value) ->
	      _popover = undefined
	      # console.log value.message
	      _popover = $(value.element).popover(
	        trigger: "manual"
	        placement: "top"
	        content: value.message
	        template: "<div class=\"popover fade in\"><div class=\"arrow\"></div><div class=\"popover-inner\"><div class=\"popover-destroy\">x</div><div class=\"popover-content\"><p></p></div></div></div>"
	      )
	      _popover.data("popover").options.content = value.message
	      $(value.element).popover "show"


	$("form").on("click",".popover-destroy",  ( =>
	  $(".popover").hide()
	))

