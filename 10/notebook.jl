### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ eab2dba8-599b-11ec-2eb5-1103cbcfa772
md"
--- Day 10: Syntax Scoring ---

You ask the submarine to determine the best route out of the deep-sea cave, but it only replies:

Syntax error in navigation subsystem on line: all of them

All of them?! The damage is worse than you thought. You bring up a copy of the navigation subsystem (your puzzle input).

The navigation subsystem syntax is made of several lines containing chunks. There are one or more chunks on each line, and chunks contain zero or more other chunks. Adjacent chunks are not separated by any delimiter; if one chunk stops, the next chunk (if any) can immediately start. Every chunk must open and close with one of four legal pairs of matching characters:

    If a chunk opens with (, it must close with ).
    If a chunk opens with [, it must close with ].
    If a chunk opens with {, it must close with }.
    If a chunk opens with <, it must close with >.

So, () is a legal chunk that contains no other chunks, as is []. More complex but valid chunks include ([]), {()()()}, <([{}])>, [<>({}){}[([])<>]], and even (((((((((()))))))))).

Some lines are incomplete, but others are corrupted. Find and discard the corrupted lines first.

A corrupted line is one where a chunk closes with the wrong character - that is, where the characters it opens and closes with do not form one of the four legal pairs listed above.

Examples of corrupted chunks include (], {()()()>, (((()))}, and <([]){()}[{}]). Such a chunk can appear anywhere within a line, and its presence causes the whole line to be considered corrupted.

For example, consider the following navigation subsystem:

[({(<(())[]>[[{[]{<()<>>

[(()[<>])]({[<{<<[]>>(

{([(<{}[<>[]}>{[]{[(<()>

(((({<>}<{<{<>}{[]{[]{}

[[<[([]))<([[{}[[()]]]

[{[{({}]{}}([{[{{{}}([]

{<[[]]>}<{[{[{[]{()[[[]

[<(<(<(<{}))><([]([]()

<{([([[(<>()){}]>(<<{{

<{([{{}}[<[[[<>{}]]]>[]]

Some of the lines aren't corrupted, just incomplete; you can ignore these lines for now. The remaining five lines are corrupted:

    {([(<{}[<>[]}>{[]{[(<()> - Expected ], but found } instead.
    [[<[([]))<([[{}[[()]]] - Expected ], but found ) instead.
    [{[{({}]{}}([{[{{{}}([] - Expected ), but found ] instead.
    [<(<(<(<{}))><([]([]() - Expected >, but found ) instead.
    <{([([[(<>()){}]>(<<{{ - Expected ], but found > instead.

Stop at the first incorrect closing character on each corrupted line.

Did you know that syntax checkers actually have contests to see who can get the high score for syntax errors in a file? It's true! To calculate the syntax error score for a line, take the first illegal character on the line and look it up in the following table:

    ): 3 points.
    ]: 57 points.
    }: 1197 points.
    >: 25137 points.

In the above example, an illegal ) was found twice (2*3 = 6 points), an illegal ] was found once (57 points), an illegal } was found once (1197 points), and an illegal > was found once (25137 points). So, the total syntax error score for this file is 6+57+1197+25137 = 26397 points!

Find the first illegal character in each corrupted line of the navigation subsystem. What is the total syntax error score for those errors?
"

# ╔═╡ 7b7ca85a-937b-4d5d-9fdb-62d5f2c22847
function solution_1(filename)
	lines = readlines(filename)
	matching = Dict(
		'[' => ']',
		'{' => '}',
		'(' => ')',
		'<' => '>',
	)
	points = Dict(
		']' => 57,
		')' => 3,
		'}' => 1197,
		'>' => 25137,
	)
	score = 0
	for line in lines
		open_chunks = Vector{Char}()
		for char in line
			if char in keys(matching)
				push!(open_chunks, char)
			elseif char in values(matching)
				if char in matching[last(open_chunks)]
					pop!(open_chunks)
				else
					println("")
					println(line)
					println("Error: Expected $last(open_chunks), but got $char")
					score += points[char]
					break
				end
			end
		end
	end
	score
end

# ╔═╡ 98975bc6-81e4-4a7e-8421-8ac4563fc8b3
solution_1("example")

# ╔═╡ db4816f1-06cf-4110-8b06-ac0d117f650a
if !(solution_1("example") == 26397)
	error("You fool")
end

# ╔═╡ 084e443e-5ad3-4fd3-930e-2e2f0b24960c
solution_1("data")

# ╔═╡ 72fc6f70-9ea8-466a-a46c-caa2214a300f
md"
--- Part Two ---

Now, discard the corrupted lines. The remaining lines are incomplete.

Incomplete lines don't have any incorrect characters - instead, they're missing some closing characters at the end of the line. To repair the navigation subsystem, you just need to figure out the sequence of closing characters that complete all open chunks in the line.

You can only use closing characters (), ], }, or >), and you must add them in the correct order so that only legal pairs are formed and all chunks end up closed.

In the example above, there are five incomplete lines:

    [({(<(())[]>[[{[]{<()<>> - Complete by adding }}]])})].
    [(()[<>])]({[<{<<[]>>( - Complete by adding )}>]}).
    (((({<>}<{<{<>}{[]{[]{} - Complete by adding }}>}>)))).
    {<[[]]>}<{[{[{[]{()[[[] - Complete by adding ]]}}]}]}>.
    <{([{{}}[<[[[<>{}]]]>[]] - Complete by adding ])}>.

Did you know that autocomplete tools also have contests? It's true! The score is determined by considering the completion string character-by-character. Start with a total score of 0. Then, for each character, multiply the total score by 5 and then increase the total score by the point value given for the character in the following table:

    ): 1 point.
    ]: 2 points.
    }: 3 points.
    >: 4 points.

So, the last completion string above - ])}> - would be scored as follows:

    Start with a total score of 0.
    Multiply the total score by 5 to get 0, then add the value of ] (2) to get a new total score of 2.
    Multiply the total score by 5 to get 10, then add the value of ) (1) to get a new total score of 11.
    Multiply the total score by 5 to get 55, then add the value of } (3) to get a new total score of 58.
    Multiply the total score by 5 to get 290, then add the value of > (4) to get a new total score of 294.

The five lines' completion strings have total scores as follows:

    }}]])})] - 288957 total points.
    )}>]}) - 5566 total points.
    }}>}>)))) - 1480781 total points.
    ]]}}]}]}> - 995444 total points.
    ])}> - 294 total points.

Autocomplete tools are an odd bunch: the winner is found by sorting all of the scores and then taking the middle score. (There will always be an odd number of scores to consider.) In this example, the middle score is 288957 because there are the same number of scores smaller and larger than it.

Find the completion string for each incomplete line, score the completion strings, and sort the scores. What is the middle score?
"

# ╔═╡ 7b21b224-7f9c-46f4-a785-d8d837d6cef0
function complete_line(chunks)
	matching = Dict(
		'[' => ']',
		'{' => '}',
		'(' => ')',
		'<' => '>',
	)
	autocomplete_points = Dict(
		')' => 1,
		']' => 2,
		'}' => 3,
		'>' => 4,
	)
	autocomplete_score = 0
	for char in reverse(chunks)
		needed = matching[char]
		autocomplete_score *= 5
		autocomplete_score += autocomplete_points[needed]

	end
	autocomplete_score
end

# ╔═╡ 95b60cc3-4091-4934-90f7-8b37669ed7ce
function solution_2(filename)
	lines = readlines(filename)
	matching = Dict(
		'[' => ']',
		'{' => '}',
		'(' => ')',
		'<' => '>',
	)
	points = Dict(
		')' => 3,
		']' => 57,
		'}' => 1197,
		'>' => 25137,
	)
	autocomplete_points = Dict(
		')' => 1,
		']' => 2,
		'}' => 3,
		'>' => 4,
	)
	autocomplete_scores = Vector{Int64}()
	for line in lines
		linescore = 0
		open_chunks = Vector{Char}()
		for char in line
			if char in keys(matching)
				push!(open_chunks, char)
			elseif char in values(matching)
				if char in matching[last(open_chunks)]
					pop!(open_chunks)
				else
					linescore += points[char]
					break
				end
			end
		end
		if linescore == 0
			push!(autocomplete_scores, complete_line(open_chunks))
		end
	end
	sort!(autocomplete_scores)
	idx = div(length(autocomplete_scores), 2) + 1
	autocomplete_scores[idx]
end

# ╔═╡ 0c8bc0e4-f7ff-414c-b0f7-9d392d3adf21
begin
	answer= solution_2("example")
	if !(answer == 288957)
		error("You fool. Your answer is $answer")
	end
end

# ╔═╡ 59d8d033-fb7a-4339-b06e-e83a0a4845ed
solution_2("data")

# ╔═╡ Cell order:
# ╟─eab2dba8-599b-11ec-2eb5-1103cbcfa772
# ╠═7b7ca85a-937b-4d5d-9fdb-62d5f2c22847
# ╠═98975bc6-81e4-4a7e-8421-8ac4563fc8b3
# ╠═db4816f1-06cf-4110-8b06-ac0d117f650a
# ╠═084e443e-5ad3-4fd3-930e-2e2f0b24960c
# ╟─72fc6f70-9ea8-466a-a46c-caa2214a300f
# ╠═7b21b224-7f9c-46f4-a785-d8d837d6cef0
# ╠═95b60cc3-4091-4934-90f7-8b37669ed7ce
# ╠═0c8bc0e4-f7ff-414c-b0f7-9d392d3adf21
# ╠═59d8d033-fb7a-4339-b06e-e83a0a4845ed
