from invoke import task, run
from colorama import init, Fore
init(autoreset=True)


@task
def clean(ctx):
    """Remove all .pyc files."""
    print(Fore.GREEN + 'Clean up .pyc files')
    run("find . -name '*.py[co]' -exec rm -f '{}' ';'")


@task
def bootstrap(ctx):
    """Bootstrap the environment."""
    print(Fore.GREEN + "\nTest requirements")
    print(run("zsh -c 'source ~/.zshrc && cd ./tests/package_python_test && sudo chown -R $USER:$USER . && tox run'"))
