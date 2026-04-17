const { express } = require('../shared.cjs');
const router = express.Router();
const { register, login, getUserInfo, editUser } = require('../controllers/userControllers.cjs');
const { isLoggedIn } = require('../middleware/authMiddleware.cjs')


router.post("/register", register);
router.post("/login", login);

router.get("/auth", isLoggedIn, async (req, res, next) => {
    try {
        res.send(req.user)
    } catch (error) {
        next(error)
    }
});

router.get("/", isLoggedIn, getUserInfo)

router.put("/edit", isLoggedIn, editUser);


module.exports = router;