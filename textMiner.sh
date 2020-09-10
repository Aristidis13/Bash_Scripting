#! /bin/bash

par=$@ #The command that will be given goes to an array called par from parameters

case ${par[@]} in
 "-f $2" )
 awk ' !/^#/ {print $0}' "$2" ;;
 "$1 -f" )
 awk ' !/^#/ {print $0}' "$1" ;;
 
#-----------------------------------------------------------End_of_1--------------------------------------------------------------#

#Στο πρώτο στάδιο η grep εντοπίζει την γραμμή με το id που έχουμε βάλει.
#Στο δεύτερο στάδιο η γραμμή γίνεται είσοδος στην awk που θέτει ως
#Field Separator το ειδικό σύμβολο | και εκτυπώνει τα ζητούμενα.
# Το \ στο \| προσδιορίζει πως το σύμβολο | δεν είναι pipe αλλά πρέπει να αντιμετωπιστεί ως αλφαριθμητικό. 
 
 "-f $2 -id $4" )
 grep -w "^$4" $2 | awk -F\| '{print $2,$3,$5}' ;;

 "-id $2 -f $4" )
 grep -w "^$2" $4 | awk -F\| '{print $2,$3,$5}' ;;

 "$1 -f $3 -id" )
 grep -w "^$3" $1 | awk -F\| '{print $2,$3,$5}' ;;

 "$1 -id $3 -f" )
 grep -w "^$1" $3 | awk -F\| '{print $2,$3,$5}' ;;

#------------------------------------------------------------End_of_2---------------------------------------------------------------#

#Αν υπάρχει γραμμή που δεν ξεκινά με #, η awk εκτυπωνει το πεδίο lastnames ή firstnames αντίστοιχα
#Τέλος κάνουμε pipe την έξοδο της awk στην εντολή sort και εκτυπώνουμε με την σημαία -u ο,τι ζητείται.

 "--lastnames -f $3" )
 awk -F"|" ' !/^#/ {print $2}' "$3" | sort -u ;;

 "--firstnames -f $3" )
 awk -F"|" ' !/^#/ {print $3}' "$3" | sort -u ;;



 "--lastnames $2 -f" )
 awk -F"|" ' !/^#/ {print $2}' "$2" | sort -u ;;

 "--firstnames $2 -f" )
 awk -F"|" ' !/^#/ {print $3}' "$2" | sort -u ;;



 "$1 -f --lastnames" )
 awk -F"|" ' !/^#/ {print $2}' "$1" | sort -u ;;

 "$1 -f --firstnames" )
 awk -F"|" ' !/^#/ {print $3}' "$1" | sort -u ;;



 "-f $2 --lastnames" )
 awk -F"|" ' !/^#/ {print $2}' "$2" | sort -u ;;

 "-f $2 --firstnames" )
 awk -F"|" ' !/^#/ {print $3}' "$2" | sort -u ;;

#-----------------------------------------------------------------End_of_3-----------------------------------------------------#
 
#H grep διώχνει όλες τις γραμμές με σχόλια μέσω -v και μέσω pipe εισάγεται στην awk.
#Για την awk θέτουμε τις ημερομηνίες ως παραμέτρους με την εντολή -v.
#Στην BEGIN προσδιορίζουμε τον κατάλληλο Field Separator.
#Μετά συγκρίνουμε ως 2 strings τις ημερομηνίες που βρίσκονται στο πεδίο 5 ($5),
#με τις παραμέτρους που έχουμε θέσει και αν είναι όλα οκ στην συνθήκη μας,
#Εκτυπώνονται οι γραμμές που υπακούουν στην ζητούμενη συνθήκη.
#Αντίστοιχα λειτουργεί το πρόγραμμα και για 1 παράμετρο.
#Έχω θέσει τις εξής υποπεριπτώσεις:Για 2 ημερομηνίες,για ημ/νια --BORN-SINCE και για ημ/νια --BORN-UNTIL 

#ΓΙΑ 2 ΗΜΕΡΟΜΗΝΙΕΣ

 "--born-since $2 --born-until $4 -f $6" )
 since_date=$2
 until_date=$4
 grep -vn '^#' $6 | awk -v x="$since_date" -v y="$until_date" 'BEGIN{FS="|"}; $5 >= x && $5 <= y {print $0};' ;;

  "--born-until $2 --born-since $4 -f $6" )
 since_date=$4
 until_date=$2
 grep -vn '^#' $6 | awk -v x="$since_date" -v y="$until_date" 'BEGIN{FS="|"}; $5 >= x && $5 <= y {print $0};' ;;

 "-f $2 --born-until $4 --born-since $6" )
 since_date=$6
 until_date=$4
 grep -vn '^#' $2 | awk -v x="$since_date" -v y="$until_date" 'BEGIN{FS="|"}; $5 >= x && $5 <= y {print $0};' ;;

 "-f $2 --born-since $4 --born-until $6" )
 since_date=$4
 until_date=$6
 grep -vn '^#' $2 | awk -v x="$since_date" -v y="$until_date" 'BEGIN{FS="|"}; $5 >= x && $5 <= y {print $0};' ;;

 "--born-since $2 -f $4 --born-until $6" )
 since_date=$2
 until_date=$6
 grep -vn '^#' $4 | awk -v x="$since_date" -v y="$until_date" 'BEGIN{FS="|"}; $5 >= x && $5 <= y {print $0};' ;;

 "--born-until $2 -f $4 --born-since $6" )
 since_date=$6
 until_date=$2
 grep -vn '^#' $4 | awk -v x="$since_date" -v y="$until_date" 'BEGIN{FS="|"}; $5 >= x && $5 <= y {print $0};' ;;

#ΓΙΑ ΗΜΕΡΟΜΗΝΙΑ ΜΟΝΟ BORN-SINCE

 "--born-since $2 -f $4" )
 since_date=$2
 grep -vn '^#' $4 | awk -v x="$since_date" 'BEGIN{FS="|"}; $5 >= x {print $0};' ;;

 "$1 --born-since -f $4" )
 since_date=$1
 grep -vn '^#' $4 | awk -v x="$since_date" 'BEGIN{FS="|"}; $5 >= x {print $0};' ;;

 "--born-since $2 $3 -f" )
 since_date=$2
 grep -vn '^#' $3 | awk -v x="$since_date" 'BEGIN{FS="|"}; $5 >= x {print $0};' ;;

 "-f $2 --born-since $4" )
 since_date=$4
 grep -vn '^#' $2 | awk -v x="$since_date" 'BEGIN{FS="|"}; $5 >= x {print $0};' ;;

 "$1 -f --born-since $4" )
 since_date=$4
 grep -vn '^#' $1 | awk -v x="$since_date" 'BEGIN{FS="|"}; $5 >= x {print $0};' ;;

 "-f $2 $3 --born-since" )
 since_date=$4
 grep -vn '^#' $2 | awk -v x="$since_date" 'BEGIN{FS="|"}; $5 >= x {print $0};' ;;

#ΓΙΑ ΗΜΕΡΟΜΗΝΙΑ ΜΟΝΟ BORN-UNTIL

 "--born-until $2 -f $4" )
 until_date=$2
 grep -vn '^#' $4 | awk -v y="$until_date" 'BEGIN{FS="|"}; $5 <= y {print $0};' ;;

 "-f $2 --born-until $4" )
 until_date=$4
 grep -vn '^#' $2 | awk -v y="$until_date" 'BEGIN{FS="|"}; $5 <= y {print $0};' ;;

 "$1 --born-until -f $4" )
 until_date=$1
 grep -vn '^#' $4 | awk -v y="$until_date" 'BEGIN{FS="|"}; $5 <= y {print $0};' ;;

 "-f $2 $3 --born-until" )
 until_date=$3
 grep -vn '^#' $2 | awk -v y="$until_date" 'BEGIN{FS="|"}; $5 <= y {print $0};' ;;

 "$1 -f $3 --born-until" )
 until_date=$3
 grep -vn '^#' $1 | awk -v y="$until_date" 'BEGIN{FS="|"}; $5 <= y {print $0};' ;;

 "$1 -f --born-until $4" )
 until_date=$4
 grep -vn '^#' $1 | awk -v y="$until_date" 'BEGIN{FS="|"}; $5 <= y {print $0};' ;;


#----------------------------------------------------------------------END_OF_4------------------------------------------------------#

 "--socialmedia -f $3" )
 awk -F\| '!/^#/ {print $8}' "$3" | sort | uniq -c | awk 'BEGIN{FS=" "} {print $2,$1}';;

 "--socialmedia $2 -f" )
 awk -F\| '!/^#/ {print $8}' "$2" | sort | uniq -c | awk 'BEGIN{FS=" "} {print $2,$1}';;

 "-f $2 --socialmedia" )
 awk -F\| '!/^#/ {print $8}' "$2" | sort | uniq -c | awk 'BEGIN{FS=" "} {print $2,$1}';;

 "$1 -f --socialmedia" )
 awk -F\| '!/^#/ {print $8}' "$1" | sort | uniq -c | awk 'BEGIN{FS=" "} {print $2,$1}';;

#Ο κώδικας ξεκινά με την awk, αγνοώντας όλες τις γραμμές που ξεκινούν με #,
#να προσδιορίζει το πεδίο 8 στο log file και στη συνέχεια να κάνει sort την piped είσοδο
#της πρώτης awk.Μετά η uniq φιλτράρει κάθε πολυπληθή είσοδο και με την κατάληξη -c 
#μετράει τα ξεχωριστά πεδία.

#--------------------------------------------------------------------END_OF_5.0-----------------------------------------------------#

#Σαν αρχή είναι καλό να μην δίνονται απευθείας πεδία ως μεταβλητές στην awk γι αυτό τα έβαλα
#σαν μεταβλητές και μετά χρησιμοποίησα την αγαπημένη awk για να δημιουργήσω ένα tmp αρχείο με τα νέα δεδομένα.
#Γενικά καλό είναι σαν προγραμματιστική αρχή να αποφεύγεται η in place αντικατάσταση και γι αυτό σκέφτηκα να φτιάξω ένα tmp.txt αρχείο
#Το tmp.txt θα αντικαταστήσει το αρχικό αρχείο.
#Θέτω OFS=\| γιατί αν δεν το κάνω θα τα εμφανίζει με κενά αντί για γραμμές, θέτω τις μεταβλητές μου και μετά προσέχω
#με την if να γίνεται αλλαγή μεταξύ πεδίων με αριθμό: 1<αριθμός<=NF.Αυτή η if θα εκτελεστεί 1 φορά και
#αν υπάρχει το id θα κάνει αλλαγή στην γραμμή, αλλιώς θα εκτελεστεί η else που θα επαναδημιουργεί τον πίνακα
#χωρίς να κάνει καμία αλλαγή.Τέλος, γίνεται αντιγραφή του αρχείου που έφτιαξε η awk στο αρχείο που θέσαμε από την case.


"-f $2 --edit "$4" "$5" $6" )
id_value="$4"
column_number="$5"
change_value="$6"
awk -v OFS=\| -v value="$change_value" -v id_n="$id_value" -v column="$column_number" 'BEGIN{FS="|"} 
 {if ( $1 == id_n && column > 1 && column <= NF)
 {$column = "";
 $column = value;
 print $0;}
 else print $0;}' "$2" > tmp.txt
 mv tmp.txt "$2" ;;


"--edit "$2" "$3" $4 -f $6" )
id_value="$2"
column_number="$3"
change_value="$4"
awk -v OFS=\| -v value="$change_value" -v id_n="$id_value" -v column="$column_number" 'BEGIN{FS="|"} 
 {if ( $1 == id_n && column > 1 && column <= NF)
 {$column = "";
 $column = value;
 print $0;}
 else print $0;}' "$6" > tmp.txt
 mv tmp.txt "$6" ;;


"$1 "$2" "$3" --edit -f $6" )
id_value="$1"
column_number="$2"
change_value="$3"
awk -v OFS=\| -v value="$change_value" -v id_n="$id_value" -v column="$column_number" 'BEGIN{FS="|"} 
 {if ( $1 == id_n && column > 1 && column <= NF)
 {$column = "";
 $column = value;
 print $0;}
 else print $0;}' "$6" > tmp.txt
 mv tmp.txt "$6" ;;


"$1 -f --edit "$4" "$5" $6" )
id_value="$4"
column_number="$5"
change_value="$6"
awk -v OFS=\| -v value="$change_value" -v id_n="$id_value" -v column="$column_number" 'BEGIN{FS="|"} 
 {if ( $1 == id_n && column > 1 && column <= NF)
 {$column = "";
 $column = value;
 print $0;}
 else print $0;}' "$1" > tmp.txt
 mv tmp.txt "$1" ;;

#--------------------------------------------------------------END_OF_5.5--------------------------------------------------------#

 * )
 echo "235839-235874" ;;
esac

#ΕΠΙΛΟΓΟΣ
#Χρησιμοποιήαμε κυρίως awk γιατί είναι μια Turing-πλήρης για strings,γλώσσα προγραμματισμού.
#ΑΝΑΠΑΝΤΗΤΑ ΕΡΩΤΗΜΑΤΑ=0
