#!/bin/bash
t=`tempfile -p muesli`
trap 'rm "$t"' EXIT
foodtable "$1" > "$t"
echo -n [
cn=0
for c in Protein 'Total lipid' 'Carbohydrate, by difference' 'Fiber, total' Potassium, Sodium, Calcium, Magnesium, Phosphorus, Iron, Iodine, Zinc, Selenium, Copper, Chromium, Manganese, Molybden Chloride Fluoride 'Vitamin A, RAE' 'Vitamin C' 'Vitamin D (' 'Vitamin E (' 'Vitamin K' Thiamin Riboflavin Niacin Pantothenic B-6 Biotin 'Folate, total' 'B-12'; do
	if [[ "$cn" = 0 ]]; then
		cn=1
	else
		echo -n ',	'
	fi
	#echo -n "$c: "
	#ghc -e "`sed -ne 's#.*'"$c"'[^	]*	\(.*\)$#\1#p' "$t" | sed -e 's#mg#/1e3#;s#µg#/1e6#;s#g##'`"
	v=$(ghc -e 'Text.Printf.printf "%.2e" ('"`sed -ne 's#.*'"$c"'[^,	]*	\(.*\)$#\1#p' "$t" | sed -e 's#mg#/1e3#;s#µg#/1e6#;s#g##'` :: Double)" 2>/dev/null)
	echo -n ${v:-idk}
done
echo ', 0]'