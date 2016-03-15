
fun valid_date (xs : int*int*int) = 
	let 
		val days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
		fun days_of_month (id : int, arr : int list) = 
			if id = 1 then hd arr
			else days_of_month(id-1, tl arr)
	in
		if #1 xs <= 0 orelse #2 xs <= 0 orelse #2 xs > 12 orelse #3 xs < 0 orelse #3 xs > (days_of_month(#2 xs, days))
		then false
		else true
	end

fun is_older (xs : int*int*int, ys : int*int*int) =
	if #1 xs <> #1 ys then #1 xs < #1 ys
	else 
		if #2 xs <> #2 ys then #2 xs < #2 ys
		else #3 xs < #3 ys

fun number_in_month (dates : (int*int*int) list, m : int) =
	if null dates then 0
	else 
		let 
			val re = number_in_month(tl dates, m)
			val first = hd dates
		in
			if #2 first <> m then re
			else 1 + re
		end

fun number_in_months (dates : (int*int*int) list, ms : int list) = 
	if null ms then 0
	else number_in_month(dates, hd ms) + number_in_months(dates, tl ms)

fun dates_in_month (dates : (int*int*int) list, m : int) =
	if null dates then []
	else 
		let 
			val re = dates_in_month(tl dates, m)
			val first = hd dates
		in
			if #2 first = m then first::re
			else re
		end

fun dates_in_months (dates: (int*int*int) list, ms: int list) =
	if null ms then []
	else dates_in_month(dates, hd ms) @ dates_in_months(dates, tl ms)

fun get_nth (xs : string list, n : int) = 
	if n = 1 then hd xs
	else get_nth(tl xs, n-1)

fun date_to_string (date: int*int*int) = 
	let
		val m = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	in
		get_nth(m, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
	end

fun number_before_reaching_sum (sum: int, xs: int list) =
	if sum - (hd xs) <= 0 then 0
	else 1 + number_before_reaching_sum(sum-(hd xs), tl xs)

fun what_month (day: int) = 
	let val days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	in 1 + number_before_reaching_sum(day, days)
	end

fun month_range (day1: int, day2: int) = 
	if day1 > day2 then []
	else what_month(day1) :: month_range(day1+1, day2)

fun oldest (dates: (int*int*int) list) = 
	if null dates then NONE
	else 
		let 
			val re = oldest(tl dates)
			val first = hd dates
		in 
			if isSome re andalso is_older(first, valOf re) then SOME(first)
			else if not (isSome re) then SOME(first)
			else re
		end

fun exist(el: int, arr: int list) =
	if null arr then false
	else 
		if el = (hd arr) then true
		else exist(el, tl arr)

fun uniq (xs: int list) =
	if null xs then []
	else 
		let val re = uniq(tl xs)
		in 
			if exist(hd xs, re) then re
			else (hd xs)::re
		end 

fun number_in_months_challenge (dates: (int*int*int) list, ms: int list) = 
	number_in_months(dates, uniq ms)

fun dates_in_months_challenge (dates: (int*int*int) list, ms: int list) = 
	dates_in_months(dates, uniq ms)

fun leap(year: int) =
	if year > 0 andalso (year mod 400 = 0 orelse (year mod 4 = 0 andalso year mod 100 <> 0)) then true
	else false

fun reasonable_date (date: int*int*int) =
	if valid_date date orelse (leap(#1 date) andalso #2 date = 2 andalso #3 date = 29) then true
	else false

	