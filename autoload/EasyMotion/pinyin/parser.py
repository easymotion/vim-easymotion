#A parser for the CC-Cedict. Convert the Chinese-English dictionary into a list of python dictionaries with "traditional","simplified", "pinyin", and "english" keys.

#Make sure that the cedict_ts.u8 file is in the same folder as this file, and that the name matches the file name on line 13.

#Before starting, open the CEDICT text file and delete the copyright information at the top. Otherwise the program will try to parse it and you will get an error message.

#Characters that are commonly used as surnames have two entries in CC-CEDICT. This program will remove the surname entry if there is another entry for the character. If you want to include the surnames, simply delete lines 59 and 60.

#This code was written by Franki Allegra in February 2020.

#Get cedict_ts.u8 from https://www.mdbg.net/chinese/dictionary?page=cedict

def parse_line(line):
    parsed = {}
    line = line.rstrip('/')
    line = line.split('/')
    if len(line) <= 1:
        return None
    english = line[1]
    char_and_pinyin = line[0].split('[')
    characters = char_and_pinyin[0]
    characters = characters.split()
    traditional = characters[0]
    simplified = characters[1]
    pinyin = char_and_pinyin[1]
    pinyin = pinyin.rstrip()
    pinyin = pinyin.rstrip(']')
    parsed['traditional'] = traditional
    parsed['simplified'] = simplified
    parsed['pinyin'] = pinyin
    parsed['english'] = english
    return parsed

def get_st():
    s = {}
    t = {}
    e = [chr(x) for x in range(ord('a'), ord('z') + 1)]
    e += [x.upper() for x in e]
    e += [chr(x) for x in range(ord('0'), ord('9') + 1)]
    # print(e)
    for line in open('cedict_ts.u8', 'r', encoding='utf-8'):
        if line[0] == '#':
            continue
        parsed = parse_line(line)
        if parsed:
            # if len(parsed['simplified']) == 1:
            #     try:
            #         print(parsed)
            #     except Exception as e:
            #         pass
            if len(parsed['simplified']) == 1 and parsed['simplified'] not in e:
                k = parsed['pinyin'][0].lower()
                s[k] = s.get(k, '') + parsed['simplified']
            if len(parsed['traditional']) == 1 and parsed['traditional'] not in e:
                k = parsed['pinyin'][0].lower()
                t[k] = t.get(k, '') + parsed['traditional']
    return (s, t)


s, _ = get_st()

with open('utf8.vim', 'w', encoding='utf-8') as fp:
    cnt = 0
    fp.write("let g:EasyMotion#pinyin#utf8 = {\n")
    for c in range(ord('a'), ord('z') + 1):
        cnt += len(s.get(chr(c), ''))
        fp.write("\t\\ '{:}' : '{}',\n".format(
            chr(c),
            '\\v|[{}]'.format(s[chr(c)]) if s.get(chr(c)) else ''))
    fp.write("\t\\}\n")
    print('cnt: ', cnt)
