// Preprocessor directive section
#include <iostream>  
#define MAX_FIB 50   

using namespace std;

int main() {
    int a, b, i, t, n;

    a = 0;
    b = 1;
    i = 1;

#ifdef MAX_FIB
    cout << "MAX_FIB is defined" << endl;
#else
    cout << "MAX_FIB is not defined" << endl;
#endif

#if MAX_FIB > 0
    cout << "Please enter the number of Fibonacci sequence terms (up to " << MAX_FIB << " terms):";
#else
    cout << "The defined maximum number of terms is zero or negative!";
    return -1;
#endif

    cin >> n; // Input the number of Fibonacci sequence terms to display

    if (n > MAX_FIB) {
        cout << "The input number exceeds the maximum limit!" << endl;
        return -1;
    }

    cout << a << endl; // The first Fibonacci number
    cout << b << endl; // The second Fibonacci number

    while (i < n) {    // Loop until the specified number of terms are displayed
        t = b;         // Temporarily store the current value of b
        b = a + b;     // Calculate the next Fibonacci number
        cout << b << endl; // Output the current Fibonacci number
        a = t;         // Assign the previous value of b to a
        i = i + 1;     // Increment the counter by 1
    }

    return 0;
}
