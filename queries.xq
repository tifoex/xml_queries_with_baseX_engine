                      (:=== HomeWork 1 ===:)
                   (:=== Advance DataBase ===:)
                (:=== Alireza Akhavan Safaei ===:)


                      (:=== Query No.1 ===:)
(:***************************************************************
   Select all the elements in the document.
****************************************************************:)
 XPath Query: //*



                      (:=== Query No.2 ===:)
(:***************************************************************
   Select all the name of the countires.
****************************************************************:)
XPath Query: //country/name


                      (:=== Query No.3 ===:)
(:***************************************************************
   Select all the names of all cities located in Peru, sorted alphabetically.
****************************************************************:)
for $c in doc("geography.xml")//country[name="Peru"]/province/city
order by $c/name
return $c/name




                      (:=== Query No.4 ===:)
(:***************************************************************
   Find all countries with more than 20 provinces. Order descending
    by the number of provinces.
****************************************************************:)
for $c in doc("geography.xml")//country
where $c[count(province)>20]
order by $c[count(province)] descending
return $c/name





                      (:=== Query No.5 ===:)
(:***************************************************************
   For each province in the United States, compute the ratio of its
    population to area, and return each province’s name, its computed
     ratio, then order them descending by the ratio.
****************************************************************:)
for $c in doc("geography.xml")//country[name="United States"]/province
let $b :=  $c/population div $c/area
order by ( $c/population div $c/area) descending
return <tag> {$b} { $c/name}</tag>



                      (:=== Query No.6 ===:)
(:***************************************************************
   Find all the provinces of the United States with population more
    than 11,000,000. Compute the ratio of each qualified state’s
     population to the whole population of the country. Return each
      state’s name and ratio. Order by the ratio in descenting order.
****************************************************************:)
for $c in doc("geography.xml")//country[name="United States"]/province
where $c/population >11000000
for $a in doc("geography.xml")//country[name="United States"]
let $d :=  $a/population
let $b :=  $c/population div $d
order by ($c/population div $d) descending
return <tag> {$c/population div $d} { $c/name}</tag>






                      (:=== Query No.7 ===:)
(:***************************************************************
   Find the names of all countries that have at least three mountains
    over 200 meters high. Then list the names and heights of all
     mountains in these countries.
****************************************************************:)
for $c in doc("geography.xml")//country
for $m in doc("geography.xml")//mountain[height>200]
let $a1 :=concat(" ", $c/@car_code)
let $a2 :=concat(" ", $c/@car_code," ")
let $a3 :=concat($c/@car_code ," ")
where $c/@car_code=$m/@country or ( contains( $m/@country,$a1) or  contains( $m/@country,$a2) or  contains( $m/@country,$a3))
let $a:= <Name> { $c/name} </Name>
let $names:=  $c/name
let $gb := concat($c/@car_code,"")
group by $gb
where count($c)>2
order by count($c) descending


return  <tag> {for $fm in doc("geography.xml")//mountain[height>200]
                where $fm/@country=$gb
                return <t> {$fm/name} {$fm/height}</t>
              }
                </tag>


                      (:=== Query No.8 ===:)
(:***************************************************************
   For each river which crosses at least 2 countries, return its name,
    and the names of the countries it crosses. Order desending by the
     numbers of countries crossed.
****************************************************************:)

for $c in (doc("geography.xml")//country/@car_code)
let $a:= data($c)
let $a1 :=concat(" ", $a)
let $a2 :=concat(" ", $a," ")
let $a3 :=concat($a ," ")
let $fa := map:merge($a1, $a2)
for $r in doc("geography.xml")//river/@country
where some $cr in $r
      satisfies ( contains( $r,$a1) or  contains( $r,$a2) or  contains( $r,$a3) )
let $s := fn:tokenize($r)

return <tag> 
            <river> {$r/../name}</river>
            <country>{ for $names in fn:tokenize($r)
                        for $C in (doc("geography.xml")//country)
                        where $names=$C/@car_code
                        order by  $C/name ascending
                        return $C/name}</country>
              </tag>

