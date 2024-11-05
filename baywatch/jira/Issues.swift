////
////  Issues.swift
////  baywatch-app
////
////  Created by thibaut robinet on 17/09/2024.
////
//
//
//
// let API_KEY = "ATATT3xFfGF02agQSjzo4jSYpCS7ZFHEz133IfldkiZK-5bSmgy08h8tx4tySLjRz-Y__V012g2nooaXYV2zXZiWne9Qm21DQzo2KjxpijZ6_wjKHA5zQOClgkieZp-uX8U1zQ2-d7JeAgz26iDHPnEHhEojsbyHRnUgNzaCFCC1stCqaxncy_k=063132DC"
//
//
//
// curl --request GET \
// --url 'https://padok.atlassian.net//rest/api/3/issue/RS-1042' \
// --user 'thibaut.robinet@theodo.com:ATATT3xFfGF02agQSjzo4jSYpCS7ZFHEz133IfldkiZK-5bSmgy08h8tx4tySLjRz-Y__V012g2nooaXYV2zXZiWne9Qm21DQzo2KjxpijZ6_wjKHA5zQOClgkieZp-uX8U1zQ2-d7JeAgz26iDHPnEHhEojsbyHRnUgNzaCFCC1stCqaxncy_k=063132DC' \
// --header 'Accept: application/json'
//
//
// "https://your-domain.atlassian.net/rest/api/3/search?jql=assignee=currentUser()+AND+resolution=Unresolved"
//
//
// curl --request GET \
// --url 'https://padok.atlassian.net//rest/api/3/issue/RS-1042' \
// --user 'thibaut.robinet@theodo.com:ATATT3xFfGF02agQSjzo4jSYpCS7ZFHEz133IfldkiZK-5bSmgy08h8tx4tySLjRz-Y__V012g2nooaXYV2zXZiWne9Qm21DQzo2KjxpijZ6_wjKHA5zQOClgkieZp-uX8U1zQ2-d7JeAgz26iDHPnEHhEojsbyHRnUgNzaCFCC1stCqaxncy_k=063132DC' \
// --header 'Accept: application/json'
//
//
// curl --request GET \
// --url "https://padok.atlassian.net/rest/api/3/search?jql=organizations=uww&fields=key" \
// --user 'thibaut.robinet@theodo.com:ATATT3xFfGF02agQSjzo4jSYpCS7ZFHEz133IfldkiZK-5bSmgy08h8tx4tySLjRz-Y__V012g2nooaXYV2zXZiWne9Qm21DQzo2KjxpijZ6_wjKHA5zQOClgkieZp-uX8U1zQ2-d7JeAgz26iDHPnEHhEojsbyHRnUgNzaCFCC1stCqaxncy_k=063132DC' \
// --header 'Accept: application/json'

// if UserDefaults.standard.object(forKey: "bdPath2") == nil {
//    //    UserDefaults.standard.set("~/.baywatch/baywatch-dotfiles", forKey: "bdPath2")
//    print("path never set")
// } else {
//    print("path already set", UserDefaults.standard.object(forKey: "bdPath2") as Any)
// }

// Remove properties add in the UserDefault with my code
// UserDefaults.standard.removeObject(forKey: "bdPath")
// UserDefaults.standard.removeObject(forKey: "bdPath2")

// List all values of UserDefault already set in the logs
// UserDefaults.standard.dictionaryRepresentation().forEach { print($0.key, $0.value) }s
