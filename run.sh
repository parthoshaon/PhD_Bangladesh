#!/bin/bash
shopt -s lastpipe

curl "https://www.aiub.edu/faculties/faculty-list/school-of-science/" | html2text| sed -n '/SL Name & ID   Department  Academic Qualification/,$p' | sed -n '/Share this content/q;p' | tail -n+2 >> AIUB_list_final.txt

curl "https://www.aiub.edu/faculties/faculty-list/school-of-engineering/" | html2text| sed -n '/SL Name & ID    Department   Academic Qualification/,$p' | sed -n '/Share this content/q;p' | tail -n+2 >> AIUB_list_final.txt

curl "https://www.aiub.edu/faculties/faculty-list/school-of-business-administration/" | html2text| sed -n '/SL  Name & ID  Department  Academic Qualification/,$p' | sed -n '/Share this content/q;p' | tail -n+2 >> AIUB_list_final.txt

curl "https://www.aiub.edu/faculties/faculty-list/school-of-arts-and-social-science/" | html2text| sed -n '/SL  Name & ID         Department      Academic Qualification Position/,$p' | sed -n '/Share this content/q;p' | tail -n+2 >> AIUB_list_final.txt

AIUB_TF=$(grep -c "....-....\|....-...\|....-.." AIUB_list_final.txt)
AIUB_TP=$(grep -i -c "DR\." AIUB_list_final.txt)
AIUB_TPP=$(echo "$AIUB_TP/$AIUB_TF" | bc -l )
AIUB_TPP=$(echo "$AIUB_TPP*100" | bc -l )
AIUB_TPP=`printf "%.1f" $AIUB_TPP`
AIUB_TPP="$AIUB_TPP%"



#==========================================================================================================

curl "http://www.northsouth.edu/about/facts.html" | grep "href=\"faculty-members" | sed "s/^.*href=\"/http\:\/\/www\.northsouth\.edu\//" | sed "s/\/\".*$/\//" >> NSU_links.txt

echo "http://ece.northsouth.edu/people/type/faculty/" >> NSU_links.txt

cat NSU_links.txt | while read link
do
	for i in {1..10}
	do
		add="${link}?page=${i}"
		echo ${add} >> NSU_list_links.txt
	done
done

cat NSU_list_links.txt | while read link
do
	curl $link | html2text >> NSU_list.txt
done 

sort NSU_list.txt | uniq >> NSU_uniq.txt

sed -n '/^\*\*/p' NSU_uniq.txt >> NSU_list_final.txt

sed -i '/Department of/d' NSU_list_final.txt

NSU_TF=$(wc -l NSU_list_final.txt | awk '{ print $1 }')
NSU_TP=$(grep -i -c "Dr\.\|Dr\_" NSU_list_final.txt)
NSU_TPP=$(echo "$NSU_TP/$NSU_TF" | bc -l )
NSU_TPP=$(echo "$NSU_TPP*100" | bc -l )
NSU_TPP=`printf "%.1f" $NSU_TPP`
NSU_TPP="$NSU_TPP%"



#===========================================================================================================

curl "https://faculty.daffodilvarsity.edu.bd/" | grep "https\:\/\/faculty\.daffodilvarsity\.edu\.bd\/teachers\/"| sed "s/^.*href=\"h/h/" | sed "s/html.*$/html/" >> DIU_links.txt

cat DIU_links.txt | while read link
do
	IFS=. read var1 var2 var3 var4 var5 <<< $link
	full="$var1.$var2.$var3.$var4"
	#/adjunctFaculty/

	#echo $var4
	IFS=/ read one two three <<< $var4
	two="/adjunctFaculty/"
	newvar4="$one$two$three"
	#echo $newvar4
	
	newfull="$var1.$var2.$var3.$newvar4.$var5"

	new1=$full
	new2=$full
	new3=$full
	
	add1="/20"
	add2="/40"
	add3="/60"

	new1+=$add1
	new2+=$add2
	new3+=$add3
	
	echo $link >> DIU_list_links.txt
	echo $new1 >> DIU_list_links.txt
	echo $new2 >> DIU_list_links.txt
	echo $new3 >> DIU_list_links.txt
	echo $newfull >> DIU_list_links.txt
done

cat DIU_list_links.txt | while read link
do
	curl $link | html2text | head -n -4 | tail -n +16 >> DIU_list.txt

done 

sort DIU_list.txt | uniq >> DIU_uniq.txt

sed -n '/^[[:blank:]][[:blank:]][[:blank:]][[:blank:]]\*[[:blank:]]\*\*\*\*/p' DIU_uniq.txt >> DIU_list_final.txt

DIU_TF=$(wc -l DIU_list_final.txt | awk '{ print $1 }')
DIU_TP=$(grep -i -c "Dr\.\|Dr\_" DIU_list_final.txt)
DIU_TPP=$(echo "$DIU_TP/$DIU_TF" | bc -l )
DIU_TPP=$(echo "$DIU_TPP*100" | bc -l )
DIU_TPP=`printf "%.1f" $DIU_TPP`
DIU_TPP="$DIU_TPP%"



#===========================================================================================================

for i in {0..5}
do
	link="https://www.bracu.ac.bd/about/leadership-and-management/faculty-and-research-staff?page=${i}"

	curl -k $link | html2text | sed -n '/School of Humanities and Social Sciences/,$p' | tail -n +29 | sed -n '/\* 2/q;p' | head -n-1 >> BRACU_list_final.txt

done

BRACU_TF=$(wc -l BRACU_list_final.txt | awk '{ print $1 }')
BRACU_TF=$((BRACU_TF/2))
BRACU_TP=$(grep -i -c "PhD" BRACU_list_final.txt)
BRACU_TPP=$(echo "$BRACU_TP/$BRACU_TF" | bc -l )
BRACU_TPP=$(echo "$BRACU_TPP*100" | bc -l )
BRACU_TPP=`printf "%.1f" $BRACU_TPP`
BRACU_TPP="$BRACU_TPP%"



#===========================================================================================================

curl "https://www.sust.edu/academics/schools#about-school1" | awk '/https\:\/\/www\.sust\.edu\/d\// && /\/faculty\//' | sed "s/^.*href=\"h/h/" | sed "s/faculty.*$/faculty/" >> SUST_links.txt

cat SUST_links.txt | while read link
do
	curl $link | html2text | sed -n '/Department Search/,$p' | tail -n+5 | sed -n '/About Us/q;p' >> SUST_list_final.txt
done 

SUST_TF=$(wc -l SUST_list_final.txt | awk '{ print $1 }')
SUST_TF=$((SUST_TF/2))
SUST_TP=$(grep -i -c "\_DR" SUST_list_final.txt)
SUST_TPP=$(echo "$SUST_TP/$SUST_TF" | bc -l )
SUST_TPP=$(echo "$SUST_TPP*100" | bc -l )
SUST_TPP=`printf "%.1f" $SUST_TPP`
SUST_TPP="$SUST_TPP%"


#===========================================================================================================


echo "No.|University Name|Total Faculty Members|Total PhD Holders|PhD Holders Percentage" >> Result.txt
echo "01|AIUB|$AIUB_TF|$AIUB_TP|$AIUB_TPP" >> Result.txt
echo "02|DIU|$DIU_TF|$DIU_TP|$DIU_TPP" >> Result.txt
echo "03|BRAC_Uni|$BRACU_TF|$BRACU_TP|$BRACU_TPP" >> Result.txt
echo "04|NSU|$NSU_TF|$NSU_TP|$NSU_TPP" >> Result.txt
echo "05|SUST|$SUST_TF|$SUST_TP|$SUST_TPP" >> Result.txt

column Result.txt -t -s "|" >> RESULT.txt

perl -pe "system 'sleep .003'" AIUB_list_final.txt

perl -pe "system 'sleep .003'" BRACU_list_final.txt 

perl -pe "system 'sleep .003'" SUST_list_final.txt 

perl -pe "system 'sleep .003'" DIU_list_final.txt 

perl -pe "system 'sleep .003'" NSU_list_final.txt

#echo ""
#echo ""
#echo "______________________________________________________________________________________"
#echo ""
#column Result.txt -t -s "|" 
#echo "______________________________________________________________________________________"
#echo ""
#echo ""
