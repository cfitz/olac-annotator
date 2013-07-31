# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

RegExp.escape = (string) =>
    return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')


jQuery ->


	if document.referrer == "http://localhost:3000/" or document.referrer == "http://olac-annotator.org/"
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
			  text_check = ".high-lit:contains('#{text}')"
			  $("#random_interest").highlight(RegExp.escape(text), { element: 'em', className: newClass + " high-lit" }) unless $(text_check).length > 0
	
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
		return false if words.length < 1 and isEmptyOk == false
		result = true
		credit = " " + credit + " "
		words = words.replace("...", "")
		checkWords = words.split " "
		for checkWord in checkWords
		  if checkWord.length > 1
		    searcher = new RegExp("(\\W|\\s)" + RegExp.escape(checkWord) + "(\\W|\\s)", "gi")
		    result = false if credit.search(searcher) < 0
		    break if result == false
		result

      
	# This checks that the name values are found in the Interest
	$.validator.addMethod "nameValueInCredit", ( (value, element) ->
    interest = $("#random_interest").text()
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
	      if $(value).hasClass("role-in-credit")
	        # issue a popover is there are values that look like they're trying to put multiple roles in a line
	        roleInCreditWarning(value) 
        else
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

  
  # This method issues a warning to try and trap anyone trying to put multiple roles in a single line. 
  roleInCreditWarning = (value) ->
    searcher = new RegExp(/\band\b|\&|\+|\/|\,/gi)
    roleText =  $(value).val()
    if roleText.search(searcher) > 0
      $(value).popover(
        trigger: "manual"
        placement: "bottom"
        content: "Warning:  If there is more than one role or function in the credit, use the 'Add a new line for another name or role” link to make a new line, repeat the name and put each role or function in its own box. For example, 'produced and directed by Jane Jones and Sam Smith” should result in four lines: (1) 'Jane Jones” and 'produced by”; (2) 'Jane Jones” and 'directed by”; (3) 'Sam Smith” and 'produced by”; (4) 'Sam Smith” and 'directed by.”"
        template: "<div class=\"popover fade in\"><div class=\"arrow\"></div><div class=\"popover-inner\"><div class=\"popover-destroy\">x</div><div class=\"popover-content\"><p></p></div></div></div>"
      )
      $(value).popover "show"
    true
  
	$("form").on("click",".popover-destroy",  ( =>
	  $(".popover").hide()
	))

