
import os
import argparse

parser = argparse.ArgumentParser("simple_example")
parser.add_argument('-t' ,'--target', help="Directory to link target in",
                    type=str, dest='target', default=None)
parser.add_argument('-d', '--dotfiles', help="Directory of the dot files",
                    type=str, dest='dotfiles')
parser.add_argument('--dry-run', help="Activate dry run", action='store_true')

args = parser.parse_args()

target_dir = args.target
HOME = os.getenv("HOME")
if target_dir is None:
    target_dir = HOME

dotfiles = args.dotfiles
if dotfiles is None:
    dotfiles = os.path.join(HOME, ".dotfiles")

dry_run = args.dry_run

ignore_file = os.path.join(dotfiles, "ignore")
if os.access(ignore_file, os.F_OK):
    with open(ignore_file, 'r') as f:
        lines = f.readlines()

    ignore = [l.strip() for l in lines]
    ignore = [l for l in ignore if not l.startswith('#')]
    ignore = [l for l in ignore if l != '']
else:
    ignore = []

ignore.append('not_to_deploy')


class Entry():

    def __init__(self, path, category, dir, link):
        self.path = path
        self.category = category
        self.link = link
        self.dir = dir

    def is_link(self):
        return self.link

    def is_file(self):
        return not self.dir

    def is_dir(self):
        return self.dir

    def check_ignore(self, ignore):
        to_ignore = False
        path_rel = os.path.relpath(self.path, dotfiles)
        for ign in ignore:
            if path_rel.startswith(ign):
                to_ignore = True
                break
        return to_ignore

    def get_target(self):
        path_rel = os.path.relpath(self.path,
                                   os.path.join(dotfiles, self.category))
        target = os.path.join(target_dir, path_rel)
        return target

    def move_target(self, dry_run):
        if self.is_link():
            self.move_link(dry_run)
        elif self.is_dir():
            self.move_dir(dry_run)
        elif self.is_file():
            self.move_file(dry_run)

    def move_link(self, dry_run):
        target = self.get_target()
        link = os.readlink(self.path)

        if os.access(target, os.F_OK):
            if os.readlink(target) == link:
                return

        print("Link %s -> %s" % (target, link))
        if not dry_run:
            try:
                os.symlink(link, target)
            except FileExistsError:
                print(f"{link} already exists.")
                pass

    def move_dir(self, dry_run):
        target = self.get_target()

        if os.access(target, os.F_OK):
            return

        print("Make dir %s" % target)
        if not dry_run:
            os.mkdir(target)

    def move_file(self, dry_run):
        target = self.get_target()
        link = self.path

        if os.access(target, os.F_OK):
            if os.path.islink(target):
                if os.readlink(target) == link:
                    return
            print("Remove %s" % (target))
            if not dry_run:
                os.remove(target)

        print("Link %s -> %s" % (target, link))
        if not dry_run:
            try:
                os.symlink(link, target)
            except FileExistsError:
                print(f"{link} already exists.")
                pass


entries = []
for category in os.scandir(dotfiles):
    if not category.name.startswith('.') and category.is_dir():
        for root, _, _ in os.walk(category.path):
            for file in os.scandir(root):
                entry = Entry(file.path, category.name, file.is_dir(), file.is_symlink())
                if not entry.check_ignore(ignore):
                    entries.append(entry)


entries.sort(key=lambda x: x.path)


for entry in entries:
    entry.move_target(dry_run)
