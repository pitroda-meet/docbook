const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.addAdminClaim = functions.https.onCall(async (data, context) => {
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError("permission-denied",
        "Must be an admin to add admin claims.",
    );
  }

  const {email} = data;

  try {
    const user = await admin.auth().getUserByEmail(email);
    await admin.auth().setCustomUserClaims(user.uid, {admin: true});
    return {message: `Admin claim set for ${email}`};
  } catch (error) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});
