from pprint import pprint

markov_matrix = {}


def calibrate_markov(city):
    city = city.strip() + "\0"
    last = ""
    index_in_city = 0

    for letter in city:
        if last == "":
            last = letter

        if last not in markov_matrix:
            markov_matrix[last] = {"is_first": 0, "is_last": 0}

        if index_in_city == 0:
            markov_matrix[last]["is_first"] += 1

        if index_in_city == (len(city) - 1):f
            markov_matrix[last]["is_last"] += 1

        if letter not in markov_matrix[last]:
            markov_matrix[last][letter] = 0

        markov_matrix[last][letter] += 1

        last = letter
        index_in_city += 1


def main():
    cities = []

    with open("../resources/communes.txt") as file:
        for line in file:
            cities.append(line)
            calibrate_markov(line)

    #calibrate_markov("paris")
    pprint(markov_matrix)


if __name__ == '__main__':
    main()
