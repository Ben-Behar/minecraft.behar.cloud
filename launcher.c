// The goal of this file is to create a PTTY and pipe data from a file into this ptty
// This will allow us to automate the commands sent to the server

#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sysexits.h>
#include <unistd.h>
#include <pty.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#define INPUT "io/input"
#define OUTPUT "io/output"


// creates a child with a pty to execute the command
int fork_pty_child(int * master_fd_pointer, char ** argv ) {
  struct winsize win = {
      .ws_col = 80, .ws_row = 24,
      .ws_xpixel = 480, .ws_ypixel = 192,
  };
  pid_t child_pid = forkpty(master_fd_pointer, NULL, NULL, &win);
  if( 0 != child_pid ) return child_pid; // if the parent was given a child (or failed) return
  execvp(argv[1], argv + 1);
  perror("exec failed");
  exit(EX_OSERR);
  return -1;
}

int fork_pipe_child(int master_fd) { // returns pid of child
  pid_t child_pid = fork();
  if( 0 != child_pid ) return child_pid; // if the parent was given a child (or failed) return
  remove(INPUT);
  int result = mkfifo(INPUT, 0666);
  if( 0 != result) printf("\ninput pipe failed: [%d]\n", result);
  while(1)
  {
    int num_read, num_to_read = 100;
    int buf[num_to_read];
    int fd = open(INPUT, O_RDONLY|O_NONBLOCK);
    printf("#initialized input pipe.\n");
    while(0 <= (num_read = read(fd, buf, num_to_read))) // while stuff is being read
      write(master_fd, buf, num_read);
  }
  exit(EX_USAGE);
  return -1;
}

int waiting_for_child(pid_t child) {
  int status;
  pid_t result = waitpid(child, &status, WNOHANG);
  if(result < 0) perror("child failed during wait");
  return result == 0; // return true if child is still going / has not changed state
}


int main (int argc, char **argv) {
  int master_fd;
  printf("begin - - -\n");
  if (argc < 2) {
    printf("Usage: %s cmd [args...]\n", argv[0]);
    exit(EX_USAGE);
  }
  pid_t pty_child_pid = fork_pty_child(&master_fd, argv );
  pid_t pipe_child_pid = fork_pipe_child(master_fd);
  int log_fd = open(OUTPUT, O_CREAT|O_RDWR, 0666 ); // open log file in write only style (create if needed)
  printf("pipe_child=%d\n", pipe_child_pid);
  printf("pty_child=%d\n", pty_child_pid);
  while(waiting_for_child(pty_child_pid))
  {
    int num_to_read = 100;
    int buf[num_to_read];
    int num_read = read(master_fd, &buf, num_to_read); // while I am able to fully read the buffer
    write(log_fd, buf, num_read);
    //dprintf(log_fd,"%s", buf);
    //printf("|%s", buf);
        //write(master_fd, "exit\n", 5);
  }
    /* now the child is attached to a real pseudo-TTY instead of a pipe,
     * while the parent can use "master_fd" much like a normal pipe */
}
