# Клас Alphabet (Алфавіт)
class Alphabet:
    def __init__(self, lang, letters):
        self.lang = lang
        self.letters = letters

    def print(self):
        print(" ".join(self.letters))

    def letters_num(self):
        return len(self.letters)

# Клас EngAlphabet (Англійський алфавіт)
class EngAlphabet(Alphabet):
    _letters_num = 26

    def __init__(self):
        super().__init__('En', list('ABCDEFGHIJKLMNOPQRSTUVWXYZ'))

    def is_en_letter(self, letter):
        return letter.upper() in self.letters

    def letters_num(self):
        return EngAlphabet._letters_num

    @staticmethod
    def example():
        return "Thanks to the DAN.IT school for the opportunity to learn the DevOps profession!"

# Тести (main)
if __name__ == "__main__":
    eng_alphabet = EngAlphabet()

    # Друк літер алфавіту
    eng_alphabet.print()

    # Вивід кількості літер в алфавіті
    print(f"Кількість букв в англійському алфавіті: {eng_alphabet.letters_num()}")

    # Перевірка, чи належить літера 'F' до англійського алфавіту
    print(f"Чи належить «F» до англійського алфавіту? {eng_alphabet.is_en_letter('F')}")

    # Перевірка, чи належить літера 'Щ' до англійського алфавіту
    print(f"Чи належить «Щ» до англійського алфавіту? {eng_alphabet.is_en_letter('Щ')}")

    # Вивід прикладу тексту англійською мовою
    print(f"Приклад тексту англійською мовою: {EngAlphabet.example()}")
