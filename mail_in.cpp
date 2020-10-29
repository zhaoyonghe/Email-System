#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>
#include <dirent.h>

using namespace std;

class mail_message {
    private:
        bool valid;
        string from;
        vector<string> to;
        vector<string> body;

    public:
        void set_valid() {
            this->valid = true;
        }
        bool is_valid() {
            return this->valid;
        }
        void set_from(string s) {
            this->from = s;
        }
        void append_to(string s) {
            this->to.push_back(s);
        }
        void append_body(string s) {
            this->body.push_back(s);
        }
        vector<string>::iterator get_to_begin_iterator() {
            return this->to.begin();
        }
        vector<string>::iterator get_to_end_iterator() {
            return this->to.end();
        }

        char* to_string() {
            string s;
            s.append("From: ");
            s.append(this->from);
            s.append("\n    To: ");
            for (int i = 0; i < this->to.size(); i++) {
                s.append(this->to[i]);
                if (i != this->to.size() - 1) {
                    s.append(", ");
                }
            }
            s.append("\n\n");
            for (int i = 0; i < this->body.size(); i++) {
                s.append(this->body[i]);
                s.append("\n");
            }

            char* res = new char [s.length() + 1];
            for (int i = 0; i < s.length(); i++) {
                res[i] = s[i]; 
            }
            res[s.length()] = '\0';

            // ~String() will be automatically called after this function call returns
            return res;
        }

        mail_message() {
            // cout << "Creating mail_message...\n";
            this->valid = false;
        }
        ~mail_message() {
            // cout << "Freeing mail_message...\n";
            // TODO
        }
};

bool is_from_line(string s) {
    if (s.size() < 13) {
        return false;
    }
    transform(s.begin(), s.end(), s.begin(), ::toupper);
    return s.find("MAIL FROM:<") == 0 && s[s.size() - 1] == '>';
}

bool is_to_line(string s) {
    if (s.size() < 11) {
        return false;
    }
    transform(s.begin(), s.end(), s.begin(), ::toupper);
    return s.find("RCPT TO:<") == 0 && s[s.size() - 1] == '>';
}

bool is_data_line(string s) {
    transform(s.begin(), s.end(), s.begin(), ::toupper);
    return s.compare("DATA") == 0;
}

bool is_valid_username(string& name) {
    DIR* dir;
	struct dirent* entry;
	dir = opendir("mail");
	if (dir == NULL) {
		return false;
	}
	while ((entry = readdir(dir)) != NULL) {
        if (name.compare(entry->d_name) == 0) {
            closedir(dir);
            return true;
        }
    }
    closedir(dir);
    return false;
}

void check_and_parse(vector<string>& lines, mail_message* msg) {
    if (lines.size() < 3) {
        return;
    }

    int n = lines.size();

    // lines.size() >= 3
    if (!is_from_line(lines[0])) {
        return;
    }

    int i = 1;
    for (; i < n; i++) {
        if (!is_to_line(lines[i])) {
            break;
        }
    }
    if (i == 1 || i == n || !is_data_line(lines[i])) {
        // no RCPT TO or no DATA or next is not DATA
        return;
    }

    // check if sender is valid
    string sender = lines[0].substr(11, lines[0].size() - 12); 
    if (!is_valid_username(sender)) {
        return;
    }

    // lines are valid
    msg->set_valid();

    msg->set_from(sender);
    for (int j = 1; j < i; j++) {
        msg->append_to(lines[j].substr(9, lines[j].size() - 10));
    }
    for (int j = i + 1; j < n; j++) {
        if (lines[j][0] == '.') {
            msg->append_body(lines[j].substr(1, lines[j].size() - 1));
            continue;
        }
        msg->append_body(lines[j]);
    }
}

void send(mail_message* msg) {
    vector<string>::iterator b = msg->get_to_begin_iterator();
    vector<string>::iterator e = msg->get_to_end_iterator();
    for (vector<string>::iterator it = b; it != e; it++) {
        // cout << "+++" << *it << "+++\n";
        int fd[2];
        char buf[it->length() + 1];
        for (int i = 0; i < it->length(); i++) {
            buf[i] = (*it)[i];
        }
        buf[it->length()] = '\0';
        pid_t p;

        if (pipe(fd) == -1) {
            fprintf(stderr, "Pipe Error!\n");
            return;
        }

        p = fork();
        if (p < 0) {
            fprintf(stderr, "Fork Error!\n");
            return;
        } else if (p == 0) {
            // child process
            close(fd[1]);  // close the writing end of the pipe
            close(STDIN_FILENO);  // close the current stdin
            dup2(fd[0], STDIN_FILENO);  // replace stdin with the reading end of the pipe
            execl("./bin/mail-out", "./bin/mail-out", buf, NULL);  // invoke mail-out
        } else {
            // parent process
            int status;
            close(fd[0]);  // close the reading end of the pipe
            char* tmp = msg->to_string();
            write(fd[1], tmp, strlen(tmp));
            delete[] tmp;
            close(fd[1]);
            p = wait(&status); 
            if (status == EXIT_SUCCESS) {
                cout << "The message has been sent to \"" << *it << "\" successfully!\n";
            } else {
                cerr << "Failed to send the message to \"" << *it << "\": the recipient name is not valid or other errors!\n";
            }
        }
    }
}

int main(int argc, char const *argv[]) {
    vector<string> lines;
    string line;
    while (getline(cin, line)) {
        if (line.compare(".") == 0) {
            mail_message msg;
            check_and_parse(lines, &msg);
            if (msg.is_valid()) {
                send(&msg);
            } else {
                cerr << "Current mail message is invalid: the format is incorrect or the sender is invalid!\n";
            }
            
            // clean up the current message
            lines.clear();
            continue;
        }
        lines.push_back(line);
    }

    if (lines.size() != 0) {
        // final message without ending with period .
        cerr << "Current mail message is invalid: final message without ending with period!\n";    
    }
    return 0;
}
