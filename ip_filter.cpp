//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//#include <cstdio>
//#include <cstdint>
//#include <chrono>

#include <iostream>
#include <string>
#include <vector>
#include <regex>

using namespace std;

//------------------------------------------------------------------------------
inline void print_ip(uint32_t ip_num)
{
    auto ip_part0 = (ip_num >> 24) & 0xFF;
    auto ip_part1 = (ip_num >> 16) & 0xFF;
    auto ip_part2 = (ip_num >>  8) & 0xFF;
    auto ip_part3 = (ip_num >>  0) & 0xFF;
    cout << ip_part0 << "." << ip_part1 << "." << ip_part2 << "." << ip_part3 << endl;
}

//------------------------------------------------------------------------------
int main(int argc, char *argv[])
{
    try {
        //std::vector<std::string> input_ip_str;
        std::vector<uint32_t>    input_ip_num;

        regex ip_whole_pat{R"(^(\S*)\s)"};
        regex ip_num_pat{R"((\d+))"};

        //--- read input stream and place to input_ip_num IP's number representations 
        for(string line; getline(cin, line);) {
            smatch match;
            if(regex_search(line, match, ip_whole_pat)) {
                //--- now we have found string representation of the whole IP (like 255.123.45.67)
                string matched_ip = match[0];
                //input_ip_str.push_back(matched_ip);
                //cout << matched_ip << endl;

                //--- convert string representation of the whole IP to the 32-bit representation
                //    this representation is very effective for fast IP searching etc.
                uint32_t ip_num = 0;
                sregex_iterator ip_iter(matched_ip.begin(), matched_ip.end(), ip_num_pat);
                for(sregex_iterator p = ip_iter; p != sregex_iterator{}; ++p) {
                    auto ip_part_num = stoi((*p)[1]);
                    auto byte_shift = (3 - distance(ip_iter, p))*8;
                    ip_num |= (ip_part_num << byte_shift);
                }
                //print_ip(ip_num);
                input_ip_num.push_back(ip_num);
            }
        }

        //--- sort in reverse order
        sort(input_ip_num.begin(), input_ip_num.end(), std::greater<>());

        //--- output results 1
        std::for_each(input_ip_num.begin(), input_ip_num.end(), [&] (auto el) { print_ip(el); } );

        //cout << endl;

        //--- output results 2 (the first byte == 1)
        std::for_each(input_ip_num.begin(), input_ip_num.end(), [&] (auto el)
            {
                if((el & 0xFF000000) == 0x01000000) {
                    print_ip(el);
                }
            }
        ); 

        //cout << endl;

        //--- output results 3 (the first byte == 46, the second byte == 70)
        std::for_each(input_ip_num.begin(), input_ip_num.end(), [&] (auto el)
            {
                if((el & 0xFFFF0000) == 0x2E460000) {
                    print_ip(el);
                }
            }
        ); 

        //cout << endl;

        //--- output results 4 (any byte == 46)
        std::for_each(input_ip_num.begin(), input_ip_num.end(), [&] (auto el)
            {
                bool res0 = ((el >> 24) & 0xFF) == 46;
                bool res1 = ((el >> 16) & 0xFF) == 46;
                bool res2 = ((el >>  8) & 0xFF) == 46;
                bool res3 = ((el >>  0) & 0xFF) == 46;

                if(res0 || res1 || res2 || res3) {
                    print_ip(el);
                }
            }
        ); 
        //cout << endl;

    }
    catch(const exception &e) {
        cerr << e.what() << endl;
    }

    return 0;
}


// 24e7a7b2270daee89c64d3ca5fb3da1a
// fd9c2a031c5f929b77bc3602bc9ec096
