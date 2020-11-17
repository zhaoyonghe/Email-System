#include <iostream>
#include <fstream>
#include <dirent.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>

using namespace std;

bool is_valid_username(string& name) {
    DIR* dir;
	struct dirent* entry;
	dir = opendir("mail");
	if (dir == NULL) {
		return false;
	}
	while ((entry = readdir(dir)) != NULL) {
        //cout << entry->d_name << "\n";
        if (name.compare(entry->d_name) == 0) {
            closedir(dir);
            return true;
        }
    }
    closedir(dir);
    return false;
}

bool write_mail(string& name, string& mail_msg) {
    string path("mail/");
    path.append(name);

    int max = 0;

    DIR* dir;
	struct dirent* entry;
	dir = opendir(path.c_str());
	if (dir == NULL) {
		return false;
	}
    errno = 0;
	while ((entry = readdir(dir)) != NULL) {
        if (strlen(entry->d_name) != 5) {
            continue;
        }
        int num = 0;
        for (int i = 0; i < 5; i++) {
            num *= 10;
            // assume entry->d_name[i] is digit character here
            num += (int)(entry->d_name[i] - '0');
        }
        if (num > max) {
            max = num;
        }
    }
    closedir(dir);

    if (errno != 0) {
        // something wrong when iterating the mails' names
        // the max is inconvincible
        return false;
    }

    if (max == 99999) {
        // mail box is full
        return false;
    }

    max++;
    string new_num("00000");
    for (int i = 0; i < 5; i++) {
        new_num[4 - i] = (char)('0' + (max % 10));
        max /= 10;
    }
    path.append("/");
    path.append(new_num);

    ofstream file(path);
    file << mail_msg;

    if (chmod(path.c_str(), S_IRGRP | S_IWGRP)) {
        return false;
    }

    return true;
}

int main(int argc, char const *argv[]) {
    //printf("Real user ID: %d\n", getuid());
    //printf("Effective user ID: %d\n", geteuid());
    //printf("Real group ID: %d\n", getgid());
    //printf("Effective group ID: %d\n", getegid());

    string name(argv[1]);
    //cout << "mail_out: " << name << endl;
    if (!is_valid_username(name)) {
        return EXIT_FAILURE;
    }
    string line;
    string mail_msg;
    //cout << "============================\n";
    while (getline(cin, line)) {
        //cout << line << endl;
        mail_msg.append(line);
        mail_msg.append("\n");
    }
    //cout << "============================\n";
    if (!write_mail(name, mail_msg)) {
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
