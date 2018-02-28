#ON/MO Panagiotis Triantis
#AM 5442

#arxika bazoume mia metablhth na periexei twn ari8mo le3ewn pou eisax8hke sto command line
#to command line anagnwrizei to keno " " oti einai o diaxwrismos twn le3ewn-entolwn
#akomh orizetai kai mia metablhth pou periexei to string pou eisax8hke sto command line
export j=$#
export p=$@
a=( $p )

#edw 8etoume gia thn askhsh mas tis metablhtes-strings pou xreiazomaste
f_used="-f"
i_d="-id"
fst="--firstnames"
lst="--lastnames"
brsn="--born-since"
brun="--born-until"
brow="--browsers"
edit="--edit"
#xrhsh metrhth apo -1 giati h metablhth "a" to prwto ths stoixeio einai to 0 opote 8eloume na eleg3oume ti eisagetai 
counter=-1;

#analogws twn le3ewn pou yparxoun sto string ginetai diamerismos se metablhtes
#akomh ginetai xrhsh kapoiwn metablhtwn ==1 gia na ginei sto programma meta o elegxos gia to ti energeia 8a epilex8ei na ginei
#me bash tis eisagwges pou exoume apo thn askhsh blepoume pws h epomenh 8esh(kai se merikes periptwseis oi epomenes 8eseis)
#apo tis metablhtes kleidia pou te8hkan parapanw periexei aparaithta stoixeia (p.x id pou 8eloume na psaksoume klp)
while [ $counter -le $j ]; do
	let counter=counter+1
	epilogh=${a[$counter]}
		if [ "$epilogh" == "$fst" ]; then
			firstname_ordering=1
		elif [ "$epilogh" = "$lst" ]; then
			lastname_ordering=1
		elif [ "$epilogh" == "$f_used" ]; then
			let minic=counter+1
			filename=${a[$minic]};
		elif [ "$epilogh" == "$i_d" ]; then
			let minic2=counter+1
			id_find=${a[$minic2]};
			id_search=1
		elif [ "$epilogh" == "$brsn" ]; then
			let minic_brsn=counter+1
			brn_since=${a[$minic_brsn]};
			brnsince=1
		elif [ "$epilogh" == "$brun" ]; then
			let minic_brun=counter+1
			brn_until=${a[$minic_brun]};
			brnuntil=1
		elif [ "$epilogh" == "$brow" ]; then
			browz=1
		elif [ "$epilogh" == "$edit" ]; then
			let minic_id=counter+1
			let minic_col=counter+2
			let minic_value=counter+3
			edddit=1
			id_change=${a[$minic_id]};
			colum=${a[$minic_col]};
			val=${a[$minic_value]};
		fi
done

#A B
#bash poswn entolwn anagnwrizei to programma gia 0 exoume mia energeia na ginei na ektypw8ei to AM
#gia 2 exoume na ektypw8ei oti periexetai sto arxeio
#an einai ish me 1 h metablhth id_search tote 3eroume pws 8eloume na psaksoume sto arxeio gia ton xrhsth me auto to id kai na 
#parousiasoume ta stoixeia tou pou zhtountai
if [ $j -eq 0 ]; then
	echo "5442"
	exit 1
elif [ $j -eq 2 ]; then
	awk -F"|" '{ if(!/^#/) print $0 }' $filename
	exit 1
elif [[ $id_search -eq 1 ]]; then
	awk -F "|" -v id_find=$id_find '{ if((!/^#/) && ($1==id_find)) { print $2 " " $3 " " $5 }}' $filename
	exit 1
fi

#C D
#8etoume thn e3odo pou dinei h awk se sorting kai meta uniq, gia na ginei alfabhtiko sortarisma twn periexomenwn pou zhtountai
#kai gia na mh typw8oun kai diplotypa antistoixa
if [[ $firstname_ordering -eq 1 ]]; then
	awk -F"|" '{ if(!/^#/) print $2}' $filename | sort | uniq
	exit
elif [[ $lastname_ordering -eq 1 ]]; then
	awk -F"|" '{if(!/^#/) print $3 }' $filename | sort | uniq
	exit
fi

#E
#apo8hkeuoume sth metablhth "metr" ton ari8mo twn grammwn pou yparxoun sto arxeio mas
metr=($(cat $filename | wc -l))

#edw trexoume olo to arxeio kai gia ka8e periptwsh an h meromhnia einai megalyterh kai ish, mikroterh kai ish, megalyterh kai ish
#apo autes pou 8eloume (exoume balei sto command line) tote typwnetai h grammh
#apo tis hm/nies gia na ginei swsth sygkrish bgazoume ta dashes(-) kai sygkrinoume tous ari8mous
#gia na ginei h sygkrish arxika gia ka8e grammh apo8hkeuoume thn hm/nia se mia metablhth, meta bgazoume ta dashes kai sygkrinoume me
#thn hmeromhnia pou mas exei dw8ei (apo thn opoia exoun afaire8ei ta (-)),an plhroi tis proypo9eseis ektypwnoume to sygkekrimeno record alliws
# proxwrame parakatw
if [[ -v brn_since && ! -v brn_until ]]; then
	dt_since=(${brn_since//-/})
	i=0
	while [ $i -le $metr ]; do
		let i=i+1
		f="$(awk -F"|" -v i_cou=$i 'NR==i_cou {if(!/^#/) {print $5}}' $filename)"
		if [[ "${f//-/}" -ge dt_since ]]; then
			awk -v ic=$i 'NR==ic {print $0}' $filename
		fi
	done
	exit
elif [[ -v brn_until && ! -v brn_since ]]; then
	dt_until=(${brn_until//-/})
	i=0
	while [ $i -le $metr ]; do
		let i=i+1
		f="$(awk -F"|" -v i_cou=$i 'NR==i_cou {if(!/^#/) {print $5}}' $filename)"
		if [[ "${f//-/}" -le dt_until ]]; then
			awk -v ic=$i 'NR==ic {print $0}' $filename
		fi
	done
	exit
elif [[ -v brn_since && -v brn_until ]]; then
	dt_since=(${brn_since//-/})
	dt_until=(${brn_until//-/})
	i=0
	while [ $i -le $metr ]; do
		let i=i+1
		f="$(awk -F"|" -v i_cou=$i 'NR==i_cou {if(!/^#/) {print $5}}' $filename)"
		if [[ "${f//-/}" -ge "$dt_since" && "${f//-/}" -le "$dt_until" ]]; then
			awk -v ic=$i 'NR==ic {print $0}' $filename
		fi
	done
	exit
fi

#F
#gi auto to erwthma afou ginei sorting kai diakritopoihsh tou pediou twn browsers
#typwnoume ta onomata se mia metablhth, meta metrame tis grammes tis metablhths kai me mia while
#gia ka8e mia grammh ths metablhths , pou periexei ena onoma apo browser se alfabhtikh seira, exontas 8esei ena counter pou
#au3anei otan briskei to idio onoma me auto pou periexetai sth metablhth metrame kai typwnoume tous browsers 
if [[ $browz -eq 1 ]]; then
	awk -F"|" '{if(!/^#/) {print $8}}' $filename | sort -f | uniq > browsers_to_print
	x="$(cat browsers_to_print | wc -l)"
	cc=0
	while [ $cc -lt $x ]; do
		let cc=cc+1
		metablhth="$(awk -v cc=$cc 'NR==cc {print $0}' browsers_to_print)"
		awk -F"|" -v metablhth1="$metablhth" 'BEGIN{OFS=" "; count=0}{if( (!/^#/) && ($8==metablhth1) ) {count++;}}END{print metablhth1,count}' $filename
	done
	exit
fi

#G
#arxika psaxnoume arxeio kai an yparxei to dosmeno id apo8hkeuetai se mia metablhth,an den yparxei 8a apo8hkeuetai null
#elegxoume to column pou do8hke an einai anamesa sto 2-8 kai an to id pou do8hke einai iso me to id pou apo8hkeusame me thn anazhthsh mas
#meta afou plhrountai oi proypo8eseis briskoume gia to sygkekrimeno id pou do8hke to periexomeno tou column pou epilex8hke kai to apo8hkeuoyme
#se mia metablhth replace, epishs briskoume kai to NR (grammh - number of record) kai to apo8hkeoume sth "line_x" meta me th sed allazoume to arxeio
#sth sygkekrimenh grammh anazhtwntas th metablhth "replace" pou 8esame kai antika8istontas me to "value" pou mas do8hke kai olo auto to pername sth "t"
#meta to t to metaferoume to arxeio mas kai etsi ginetai h epi8ymhth allagh sto arxeio mas
if [[ -v edit && -v id_change && -v colum && -v val ]]; then
	id_ch="$(awk -F "|" -v id_change=$id_change '{ if((!/^#/) && ($1==id_change)) { print $1 }}' $filename)";
	if [[ ( "$colum" -gt 8 || "$colum"  -lt 2 ) && "$id_change" -ne "$id_ch" ]]; then
		exit
	fi
	if [[ "$id_change" -eq "$id_ch" && "$colum" -le 8 && "$colum" -ge 2 ]]; then
		replace="$(awk -F"|" -v id_change=$id_change -v colum=$colum -v val=$val '{ if((!/^#/) && ($1==id_change)) { print $colum}}' $filename)";
		line_x="$(awk -F"|" -v id_change=$id_change -v colum=$colum -v val=$val '{ if((!/^#/) && ($1==id_change)) {print NR}}' $filename)";
		sed  "$line_x"s/$replace/$val/ $filename > t
		mv t $filename
		exit
	fi
	exit
fi