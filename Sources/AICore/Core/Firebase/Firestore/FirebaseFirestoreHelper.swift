//
//  FirebaseHelpers.swift
//  Instant
//
//  Created by Alexy Ibrahim on 11/8/22.
//

import Foundation
import FirebaseFirestore

public class FirebaseFirestoreHelper {
    static let shared = FirebaseFirestoreHelper()
    
    public static var db: Firestore!
    
    public final class func collectionRef(collectionName: String) -> CollectionReference {
        let ref = db.collection(collectionName)
        return ref
    }
    
    public final class func documentRef(collectionName: String, documentId: String) -> DocumentReference {
        let ref = collectionRef(collectionName: collectionName).document(documentId)
        return ref
    }
    
    public final class func addDocument(collectionName: String, data: [String: Any], documentId: String? = nil) -> DocumentReference? {
        if let documentId = documentId {
            let ref: DocumentReference? = documentRef(collectionName: collectionName, documentId: documentId)
            ref?.setData(data, completion: { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            })
            return ref
        } else {
            var ref: DocumentReference? = nil
            ref = collectionRef(collectionName: collectionName).addDocument(data: data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            return ref
        }
        
    }
    
    public final class func updateDocument(collectionName: String, data: [String: Any], documentId: String, callback: GenericClosure<Error?>? = nil) -> DocumentReference? {
        let ref: DocumentReference? = documentRef(collectionName: collectionName, documentId: documentId)
        ref?.updateData(data, completion: { err in
            if let err = err {
                print("Error updated document: \(err)")
                callback?(err)
            } else {
                print("Document updated with ID: \(ref!.documentID)")
                callback?(nil)
            }
        })
        return ref
    }
    
    public final class func readDocuments(collectionName: String) {
        collectionRef(collectionName: collectionName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    public final class func readDocument(collectionName: String, documentId: String, source: FirestoreSource? = nil, callback: GenericClosure<[String: Any]>? = nil, errorCallback: GenericClosure<Error>? = nil, emptyDataCallback: VoidClosure? = nil) {
        let docRef = documentRef(collectionName: collectionName, documentId: documentId)
        docRef.getDocument(source: source ?? .default) { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                guard let data = document.data() else {
                    print("\(docRef.path) - Document data was empty.")
                    emptyDataCallback?()
                    return
                }
                callback?(data)
            } else {
                errorCallback?(error!)
            }
        }
    }
    
    public final class func readDocumentRealmtime(collectionName: String, documentId: String, includeMetadataChanges: Bool? = nil, callback: GenericClosure<[String: Any]>? = nil, errorCallback: GenericClosure<Error>? = nil, emptyDataCallback: VoidClosure? = nil) -> ListenerRegistration {
        let docRef = documentRef(collectionName: collectionName, documentId: documentId)
        let listener = docRef
            .addSnapshotListener(includeMetadataChanges: includeMetadataChanges ?? false) { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("\(docRef.path) - Error fetching document: \(error!)")
                    errorCallback?(error!)
                    return
                }
                guard let data = document.data() else {
                    print("\(docRef.path) - Document data was empty.")
                    emptyDataCallback?()
                    return
                }
                callback?(data)
            }
        return listener
    }
}
