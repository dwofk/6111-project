f = open('london.coe', 'r')
y =open('londond_hex.txt','w')
final=''
for line in f:
	newone=''
	counter=0
	sub=''
	inter=0
	inter2=0
	for letter in line:
		#print letter
		counter+=1
		sub+=letter
		if counter==4:
			#print sub
			if sub=='0000':
				sub="0"
			if sub=='0001':
				sub="1"
			if sub=='0010':
				sub="2"
			if sub=='0011':
				sub="3"
			if sub=='0100':
				sub="4"
			if sub=='0101':
				sub="5"
			if sub=='0110':
				sub="6"
			if sub=='0111':
				sub="7"
			if sub=='1000':
				sub="8"
			if sub=='1001':
				sub="9"
			if sub=='1010':
				sub="A"
			if sub=='1011':
				sub="B"
			if sub=='1100':
				sub="C"
			if sub=='1101':
				sub="D"
			if sub=='1110':
				sub="E"
			if sub=='1111':
				sub="F"
			#print sub
			inter+=1
			if inter==2:
				sub=sub+' '
				inter=0
			inter2+=1
			if inter2==4:
				inter2=0
				sub=sub+'\n'
			counter=0
			final+=sub
			sub=''
y.write(final)