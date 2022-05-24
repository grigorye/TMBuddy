# Running macOS GH actions locally

This is an experiment on employing [act](https://github.com/nektos/act) with macOS-specific actions via ssh-ing into the local (macOS) users.

## Requirements

-   Local admin rights
-   GH secrets exported into ` .secrets`
-   `.env`/`.secrets` with `SSHPASS` (see below runner password).

## Initial setup

```brew install act --HEAD```

```brew install vnc-viewer```

Create a keychain entry, that holds the password for every runner utilized, name it TM-Buddy-Runner.

## Runners setup

1.   Create 4 runners:
     ```./GHALocal/RunnerSetup/CreateUsersForRunners 4 tm-buddy-runner- TM-Buddy-Runner```
2.   Enable key-based ssh into the first runner (used as the coordinator):
     ```ssh-copy-id tm-buddy-runner-1@localhost```
3.   Launch VNC server to support runner activation (necessary for snapshot tests) (might be killed after the runner activation):
     ```./GHALocal/RunnerSetup/Launch-VNC-Tunnel```
4.   Activate the runners:
     ```./GHALocal/RunnerSetup/ActivateRunners 4 tm-buddy-runner- TM-Buddy-Runner```

Steps 3 and 4 should be done after every reboot or runner (re)creation.

## Running

-   Just tests ( `-j tests`):
    `./GHALocal/bin/gh-build-local --rm --env REMOTE_RUNNER_USER_PREFIX=tm-buddy-runner --env REMOTE_RUNNER_COUNT=4 -j tests`
-   Just build-app (`-j build-app`):
    `./GHALocal/bin/gh-build-local --rm --env REMOTE_RUNNER_USER_PREFIX=tm-buddy-runner --env REMOTE_RUNNER_COUNT=4 -j build-app`
-   Everything (no `-j`):
    `./GHALocal/bin/gh-build-local --rm --env REMOTE_RUNNER_USER_PREFIX=tm-buddy-runner --env REMOTE_RUNNER_COUNT=4`

## Troubleshooting

-   Runner is not able to exercise the tests:

    1.  Delete the runners: 
        `./GHALocal/RunnerSetup/DeleteUsersForRunners 4 tm-buddy-runner-`
    2.  Create the new set of runners (follow Runners setup)
-   The file system is full:
    -   Do the cleanup of the leaked files:
        `./GHALocal/gh-cleanup`

## Beware

-   Currently there's huge amount of files leaking on every run.