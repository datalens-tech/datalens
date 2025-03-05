import sys
import json

from cryptography.fernet import Fernet

def main():
  fernet = Fernet(sys.argv[1])

  encrypted = fernet.encrypt(sys.argv[2].encode('utf-8')).decode()

  print(encrypted)

main()
