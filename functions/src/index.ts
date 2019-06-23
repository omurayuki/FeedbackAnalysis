import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { FieldValue } from '@google-cloud/firestore';
admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();

interface Post {
    readonly genre: [string];
    readonly new_things: string;
    readonly goal: [{string: string}];
    readonly deadline: string;
    readonly achived_flag: boolean;
    readonly draft_flag: boolean;
    readonly like_count: number;
    readonly commented_count: number;
    readonly created_at: FieldValue;
    readonly updated_at: FieldValue;
}

interface RootPost extends Post {
    authorRef?: FirebaseFirestore.DocumentReference;
}

export const onUserPostCreate = functions.firestore.document('/Users/{userId}/Goals/{postId}').onCreate(async (snapshot, context) => {
    await copyToRootWithUsersPostSnapshot(snapshot, context);
});

export const onUsersPostUpdate = functions.firestore.document('/Users/{userId}/Goals/{postId}').onUpdate(async (change, context) => {
    await copyToRootWithUsersPostSnapshot(change.after, context);
});

export const onUserPostDelete = functions.firestore.document('/Users/{userId}/Goals/{postId}').onDelete(async (snapshot, _) => {
    await deleteToRootWithUsersPostSnapshot(snapshot);
});

async function copyToRootWithUsersPostSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot, context: functions.EventContext) {
    const postId = snapshot.id;
    const userId = context.params.userId;
    const post = snapshot.data() as RootPost;
    post.authorRef = firestore.collection('Users').doc(userId);
    await firestore.collection('Goals').doc(postId).set(post, { merge: true });
}

async function deleteToRootWithUsersPostSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot) {
    const postId = snapshot.id;
    await firestore.collection('Goals').doc(postId).delete();
}