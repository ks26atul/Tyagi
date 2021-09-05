#!/usr/bin/perl
#=========================================================================
# This program develop for training, testing  and evaluating SVM_light
# using N fold cross validation for classification
# Usage: program train_file(SVM format) N (fold) SVM_param (SVM parmeters)
#==========================================================================

if($#ARGV >= 2){
    $file1 = $ARGV[0];
    $fold = $ARGV[1];
    $comm = $ARGV[2];
    $svml = "/home/atul/Desktop/cpp2/progs/svm_learn";
    $svmc = "/home/atul/Desktop/cpp2/progs/svm_classify";
    
#create test sets
    
    
    open(FR,">>Result");
    
    print FR "# thr   sn     sp     acc    mcc   | SVM param : $fold fold  train=$file1 \n";
    open(FC,"$comm");
    while($tc1=<FC>){
	chomp($tc1);
	if(length($tc1) > 0){
	    print "=============== $tc1 ================ \n";
#    print FR "=============== $tc1 ================ \n";
	    $ssn=$ssp=$sacc=$smcc=0;
	    $loop=0;
	    for($i1=1; $i1 <= $fold; $i1++){
		$count = $i1 - 1;
		open(FP1,"$file1");
		open(FR1,">te");
		open(FR2,">tr");
		while($t1=<FP1>){
		    if(($count%$fold) == 0){print FR1 $t1;} else{print FR2 $t1;}
		    $count++;
		}
		close FP1;
		close FR1;
		close FR2;
		system("$svml $tc1 tr model ");
		system("$svmc te model output");
		$a1=0;
		@thr=qw(-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1);
		for($t=0;$t<=@thr;$t++){
		    open(FR3,"/home/atul/Desktop/cpp2/progs/eval.pl te output $thr[$t]|");
		    $tr3 = <FR3>;
		    chomp($tr3);
		    @fi = split(" ",$tr3);
		    $ssn[$a1] = $ssn[$a1] + $fi[0];
		    $ssp[$a1] = $ssp[$a1] + $fi[1];
		    $sacc[$a1] = $sacc[$a1] + $fi[2];
		    $smcc[$a1] = $smcc[$a1] + $fi[3];
#   print FR "$tr3 \n";
		    
		    $a1++;		    
		    #print "$t\n";
		    #close FR3;
		} 
                $loop++;
		if($loop==$fold){
		    for($a=0;$a<=20;$a++){  
			$ssn = $ssn[$a]/$fold; $ssn[$a]=0;
			$ssp = $ssp[$a]/$fold; $ssp[$a]=0;
			$sacc = $sacc[$a]/$fold; $sacc[$a]=0;
			$smcc = $smcc[$a]/$fold; $smcc[$a]=0;
			
			printf(FR " %-5.1f  %-5.2f  %-5.2f  %-5.2f  %-5.2f | %s \n",@thr[$a],$ssn,$ssp,$sacc,$smcc,$tc1);
		    }
		    
		}
	    }		
	}
    }
}

else{
    print "#========================================================================= \n";
    print "# This program develop for training, testing  and evaluating SVM_light \n";
    print "# using N fold cross validation \n";
    print "# Usage: program train_file(SVM format) N (fold) SVM_param (SVM parmeters) \n";
    print "#==========================================================================\n";
}
print"\n";
