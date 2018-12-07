function fish_prompt
	# Test if we're in a git repo, and gather some info
	set --global git_status (git status 2>/dev/null)
	
	if test (count $git_status) != 0
		set --local git_branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
		printf '%s%s%s%s%s%s%s%s%s%s%s' (set_color purple) (prompt_pwd) (set_color 69C) " ($git_branch)" (set_color b40) ' ❱' (set_color E82) '❱' (set_color EB2) '❱ ' (set_color normal)
	else
		printf '%s%s%s%s%s%s%s%s%s' (set_color purple) (prompt_pwd) (set_color b40) ' ❱' (set_color E82) '❱' (set_color EB2) '❱ ' (set_color normal)
	end
end


function fish_right_prompt
	# Store the status of the previous command
	# (used later to mark with an x on error)
	set previous_status $status
	
	# Test if we're in a git repo
	if test (count $git_status) != 0
	
		# Check for unstaged changes
		if echo $git_status | grep -q 'Changes not staged'
			echo (set_color red) '● '
		else
			# Check if remote is ahead (for some reason `else if` fails on this, so I'm using nested if instead)
			if echo $git_status | grep -q 'Your branch is behind'
				echo (set_color red) '○ '
			else
				echo (set_color normal) '● '
			end
		end
	end
	
	# Mark an error with an x
	if test $previous_status != '0'
		echo (set_color red) '✖ '
	end

end
