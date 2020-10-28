default: clean in out
	./create-tree.sh $(TREE)
	cp mail-in mail-out $(TREE)/bin
	cp 00001 $(TREE)/inputs
	cp test.sh $(TREE)

in:
	g++ mail_in.cpp -o mail-in

out:
	g++ mail_out.cpp -o mail-out

clean:
	rm mail-in mail-out || true